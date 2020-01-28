function init()
  if storage.dimensionalParameter == nil then
    -- a random number between 1 and 10^18-1
    storage.dimensionalParameter = math.random(1, 999999999999999999)
  end

  if storage.active == nil then
    storage.active = false
  end
  updateActive()

  message.setHandler("getDimensionalParameter", function()
      return storage.dimensionalParameter
    end)

  message.setHandler("setDimensionalParameter", function(_, _, value)
      storage.dimensionalParameter = value
    end)
end

function update()
  local active = true
  if object.isInputNodeConnected(0) then
    active = object.getInputNodeLevel(0)
  end
  if storage.active ~= active then
    storage.active = active
    updateActive()
  end
end

function updateActive()
  if storage.active then
    animator.setAnimationState("teleporter", "on")
  else
    animator.setAnimationState("teleporter", "off")
  end
  object.setInteractive(storage.active)
end
