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

require_relative '../spec_helper'

RSpec.describe Ladybug::EnergyModel do
  it 'has a version number' do
    expect(Ladybug::EnergyModel::VERSION).not_to be nil
  end

  it 'has a measures directory' do
    extension = Ladybug::EnergyModel::Extension.new
    expect(File.exist?(extension.measures_dir)).to be true
  end
  
  it 'has a files directory' do
    extension = Ladybug::EnergyModel::Extension.new
    expect(File.exist?(extension.files_dir)).to be true
  end
  
  it 'has a valid schema' do
    extension = Ladybug::EnergyModel::Extension.new
    expect(extension.schema.nil?).to be false
    expect(extension.schema_valid?).to be true
    expect(extension.schema_validation_errors.empty?).to be true
  end
 
  it 'can load and validate example face by face model' do
    file = File.join(File.dirname(__FILE__), '../files/example_face_by_face_model.json')
    model = Ladybug::EnergyModel::Model.read_from_disk(file) 
    expect(model.valid?).to be true
    expect(model.validation_errors.empty?).to be true 
    model.to_openstudio_model
  end

  it 'can load and validate opaque construction' do
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/construction_internal_floor.json')
    construction1 = Ladybug::EnergyModel::EnergyConstructionOpaque.read_from_disk(file)
    expect(construction1.valid?).to be true
    expect(construction1.validation_errors.empty?).to be true
    object1 = construction1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil
    
    # load the same construction again in the same model, should find existing construction
    construction2 = Ladybug::EnergyModel::EnergyConstructionOpaque.read_from_disk(file)
    expect(construction2.valid?).to be true
    expect(construction2.validation_errors.empty?).to be true
    object2 = construction2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end
  
  it 'can load and validate transparent construction' do
    openstudio_model = OpenStudio::Model::Model.new 
    file = File.join(File.dirname(__FILE__), '../files/construction_window.json')
    construction1 = Ladybug::EnergyModel::EnergyConstructionTransparent.read_from_disk(file) 
    expect(construction1.valid?).to be true
    expect(construction1.validation_errors.empty?).to be true
    object1 = construction1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    construction2 = Ladybug::EnergyModel::EnergyConstructionTransparent.read_from_disk(file)
    expect(construction2.valid?).to be true
    expect(construction2.validation_errors.empty?).to be true
    object2 = construction2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy material' do
    openstudio_model = OpenStudio::Model::Model.new 
    file = File.join(File.dirname(__FILE__), '../files/in_material.json')
    material1 = Ladybug::EnergyModel::EnergyMaterial.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    material2 = Ladybug::EnergyModel::EnergyMaterial.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy material no mass' do 
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/in_material_no_mass.json')
    material1 = Ladybug::EnergyModel::EnergyMaterialNoMass.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil 

    material2 = Ladybug::EnergyModel::EnergyMaterialNoMass.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true 
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy window material air gap' do
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/in_window_air_gap.json')
    material1 = Ladybug::EnergyModel::EnergyWindowMaterialAirGap.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    material2 = Ladybug::EnergyModel::EnergyWindowMaterialAirGap.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy window material simple glazing system' do
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/in_window_simpleglazing.json')
    material1 = Ladybug::EnergyModel::EnergyWindowMaterialSimpleGlazSys.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    material2 = Ladybug::EnergyModel::EnergyWindowMaterialSimpleGlazSys.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy window material blind' do
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/in_window_blind.json')
    material1 = Ladybug::EnergyModel::EnergyWindowMaterialBlind.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    material2 = Ladybug::EnergyModel::EnergyWindowMaterialBlind.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy window material glazing' do
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/in_window_glazing.json')
    material1 = Ladybug::EnergyModel::EnergyWindowMaterialGlazing.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    material2 = Ladybug::EnergyModel::EnergyWindowMaterialGlazing.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  it 'can load and validate energy window material shade' do
    openstudio_model = OpenStudio::Model::Model.new
    file = File.join(File.dirname(__FILE__), '../files/in_window_shade.json')
    material1 = Ladybug::EnergyModel::EnergyWindowMaterialShade.read_from_disk(file)
    expect(material1.valid?).to be true
    expect(material1.validation_errors.empty?).to be true
    object1 = material1.to_openstudio(openstudio_model)
    expect(object1).not_to be nil

    material2 = Ladybug::EnergyModel::EnergyWindowMaterialShade.read_from_disk(file)
    expect(material2.valid?).to be true
    expect(material2.validation_errors.empty?).to be true
    object2 = material2.to_openstudio(openstudio_model)    
    expect(object2).not_to be nil
    expect(object2.handle.to_s).to eq(object1.handle.to_s)
  end

  #it 'can create an opaque material' do
    
  #  material1 = Ladybug::EnergyModel::EnergyMaterial.new
  #  material1.roughness = 'MediumRough'
  #  material1.thickness = 0.01
  #  material1.conductivity = 0.6
  #  material1.specific.heat = 4185
  #  material1.thermal_absorptance = 0.95
  #  material1.solar_absorptance = 0.7
  #  material1.visible_abosrptance = 0.7

  #  openstudio_material = material1.to_openstudio

  #  expect(openstudio_material.roughness).to be eq('MediumRough')
  #  expect(openstudio_material.thickness).to be eq(0.01)
  #  expect(openstudio_material.conductivity).to be eq(0.6)
  #  expect(openstudio_material.specific_heat).to be eq(4185)
  #  expect(openstudio_material.thermal_absorptance).to be eq(0.95)
  #  expect(openstudio_material.solar_absorptance).to be eq(0.7)
  #  expect(openstudio_material.visible_abosrptance).to be eq(0.7)

  #end

  #it 'can raise error if outermost layer in window construction is airgap' do 
  #  openstudio_model = OpenStudio::Model::Model.new
  #  file = File.join(File.dirname(__FILE__), '../files/construction_window_wrong.json')
  #  construction1 = Ladybug::EnergyModel::EnergyConstructionTransparent.read_from_disk(file)
  #  construction1 = Ladybug::EnergyModel::EnergyConstructionTransparent.read_from_disk(file)
  #  expect(construction1.valid?).to be true
  #  expect(construction1.validation_errors.empty?).to be false
  #  expect(construction1.validation_errors.include? "Air Gap")
  #  object1 = construction1.to_openstudio(openstudio_model)
  #  expect(object1).to be nil #to not be true in case of transparent material

  #  construction2 = Ladybug::EnergyModel::EnergyConstructionTransparent.read_from_disk(file)
  #  expect(construction2.valid?).to be true
  #  expect(construction2.validation_errors.empty?).to be true #it raises error in which the string contains "transparent layer"
  #  object2 = construction2.to_openstudio(openstudio_model)    
  #  expect(object2).not_to be nil
  #  expect(object2.handle.to_s).to eq(object1.handle.to_s)
  #end

end