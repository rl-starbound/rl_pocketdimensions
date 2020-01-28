function init()
  self.sounds = config.getParameter("sounds")

  self.dimensionalParameterMessage = world.sendEntityMessage(pane.sourceEntity(), "getDimensionalParameter")
end

function dismissed()
  for _, sound in pairs(self.sounds) do
    pane.stopAllSounds(sound)
  end
end

function update(dt)
  if self.dimensionalParameterMessage and self.dimensionalParameterMessage:finished() then
    if self.dimensionalParameterMessage:succeeded() then
      self.dimensionalParameter = self.dimensionalParameterMessage:result()
      if self.dimensionalParameter ~= nil then
        widget.setText("dimensionalParameter", self.dimensionalParameter)
      end
    else
      pane.playSound(self.sounds.error)
      sb.logError("Tesseract Lens interface failed to retrieve dimensional parameters.")
    end
    self.dimensionalParameterMessage = nil
  end

  widget.setButtonEnabled("activateButton", self.dimensionalParameter ~= nil)
end

function activateTesseractLens()
  if self.dimensionalParameter == nil then return end
  player.warp(string.format("InstanceWorld:pocketdimension:%032d", self.dimensionalParameter), "beam")
  pane.dismiss()
end

function changeDimensionalParameter()
  self.dimensionalParameter = tonumber(widget.getText("dimensionalParameter"))
  world.sendEntityMessage(pane.sourceEntity(), "setDimensionalParameter", self.dimensionalParameter)
end

function randomizeDimensionalParameter()
  widget.setText("dimensionalParameter", math.random(1, 999999999999999999))
end
