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

require 'ladybug/energy_model/model_object'

require 'json-schema'
require 'json'
require 'openstudio'

module Ladybug
  module EnergyModel      
    class EnergyWindowMaterialAirGap < ModelObject
      attr_reader :errors, :warnings

      def initialize(hash)
        super(hash)

        raise "Incorrect model type '#{@type}'" unless @type == 'EnergyWindowMaterialAirGap'
      end
      
      private
      
      def find_existing_openstudio_object(openstudio_model)
        object = openstudio_model.getGasByName(@hash[:name]) 
        if object.is_initialized
          return object.get
        end
        return nil
      end
      
      def create_openstudio_object(openstudio_model)
        openstudio_window_airgap = OpenStudio::Model::Gas.new(openstudio_model)
         openstudio_window_airgap.setName(@hash[:name]) 
        openstudio_window_airgap.setGasType(@hash[:gastype])
        openstudio_window_airgap.setThickness(@hash[:thickness])
        openstudio_window_airgap.setConductivityCoefficientA(@hash[:conductivity_coeff_A].to_f)
        openstudio_window_airgap.setConductivityCoefficientB(@hash[:conductivity_coeff_B].to_f)
        openstudio_window_airgap.setConductivityCoefficientC(@hash[:conductivity_coeff_C].to_f)
        openstudio_window_airgap.setViscosityCoefficientA(@hash[:viscosity_coeff_A].to_f)
        openstudio_window_airgap.setViscosityCoefficientB(@hash[:viscosity_coeff_B].to_f)
        openstudio_window_airgap.setViscosityCoefficientC(@hash[:viscosity_coeff_C].to_f)
        openstudio_window_airgap.setSpecificHeatCoefficientA(@hash[:specific_heat_coeff_A].to_f)
        openstudio_window_airgap.setSpecificHeatCoefficientB(@hash[:specific_heat_coeff_B].to_f)
        openstudio_window_airgap.setSpecificHeatCoefficientC(@hash[:specific_heat_coeff_C].to_f)
        openstudio_window_airgap.setSpecificHeatRatio(@hash[:specific_heat_ratio].to_f)
        openstudio_window_airgap.setMolecularWeight(@hash[:molecular_weight].to_f)

        return openstudio_window_airgap
      end

    end # EnergyWindowMaterialAirGap
  end # EnergyModel
end # Ladybug
