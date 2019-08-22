# *******************************************************************************
# Ladybug Tools Energy Model Schema, Copyright (c) 2019, Alliance for Sustainable
# Energy, LLC, Ladybug Tools LLC and other contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# (1) Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# (2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# (3) Neither the name of the copyright holder nor the names of any contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission from the respective party.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY CONTRIBUTORS, THE
# UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
# THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# *******************************************************************************

require 'ladybug/energy_model/extension'
require 'ladybug/energy_model/model_object'
require 'ladybug/energy_model/energy_construction_opaque'
require 'ladybug/energy_model/face'
require 'ladybug/energy_model/shade_face'

require 'json-schema'
require 'json'
require 'openstudio'

module Ladybug
  module EnergyModel
    class Model
      attr_reader :errors, :warnings

      # Read Ladybug Energy Model JSON from disk
      def self.read_from_disk(file)
        hash = nil
        File.open(File.join(file), 'r') do |f|
          hash = JSON.parse(f.read, symbolize_names: true)
        end

        Model.new(hash)
      end

      # Load ModelObject from symbolized hash
      def initialize(hash)
        # initialize class variable @@extension only once
        @@extension ||= Extension.new
        @@schema ||= @@extension.schema

        @hash = hash
        @type = @hash[:type]
        raise 'Unknown model type' if @type.nil?
        raise "Incorrect model type '#{@type}'" unless @type == 'Model'
        #puts "3HELLO = #{@hash}"

      end

      # check if the model is valid
      #def valid?
      #  return validation_errors.empty?
      #end

      # return detailed model validation errors
      #def validation_errors
      #  JSON::Validator.fully_validate(@@schema, @hash)
      #end

      # convert to openstudio model, clears errors and warnings
      def to_openstudio_model(openstudio_model = nil)
        @errors = []
        @warnings = []

        @openstudio_model = if openstudio_model
                              openstudio_model
                            else
                              OpenStudio::Model::Model.new
                            end

        create_openstudio_objects

        @openstudio_model
      end

      private

      # create openstudio objects in the openstudio model
      def create_openstudio_objects
        create_rooms
      end

      #add if statement in case rooms are empty 
      def create_rooms
        @hash[:rooms].each do |room|
          room_object = Room.new(room)
          room_object.to_openstudio(@openstudio_model)
        end
      end

      def create_constructions
        @hash[:properties][:energy][:constructions].each do |construction|
          name = construction[:name]
          construction_type = construction[:type]
          construction_object = nil
          
          case construction_type
          when 'OpaqueConstructionAbridged'
            construction_object = OpaqueConstructionAbridged.new(construction)
          when 'WindowConstructionAbridged'
            construction_object = WindowConstructionAbridged.new(construction)
          when 'ShadeConstruction'
            construction_object = ShadeConstruction.new(construction)
          else
            raise "Unknown construction type #{construction_type}."
          end
        end
      end

      def create_construction_set
        @hash[:properties][:energy][:construction_sets].each do |construction_set|
          construction_set = ConstructionSet.new(construction_set)
        end
      end

      def create_orphaned_shades
        @hash[:properties][:orphaned_shades].each do |shade|
          shade = Shade.new(shade)
        end
      end

      def create_orphaned_faces
        if @hash[:properties][:orphaned_faces]
          raise "Face is not translatable to OpenStudio object."
        end
      end

      def create_orphaned_apertures
        if @hash[:properties][:orphaned_apertures]
          raise "Aperture is not translatable to OpenStudio object."
        end
      end
      
      def create_orphaned_doors
        if @hash[:properties][:orphaned_doors]
          raise "Door is not translatable to OpenStudio object."
        end
      end

        # for now make parent a space, check if should be a zone?

        # add if statement and to_openstudio object
        # if air_wall
        # DLM: todo
        # end
      
    end # Model
  end # EnergyModel
end # Ladybug
