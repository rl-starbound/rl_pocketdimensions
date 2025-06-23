function init()
  if storage.dimensionalParameter == nil then
    local min = 1
    local max = 999999999999999999 -- 10^18-1
    storage.dimensionalParameter = math.min(max, math.max(min, math.floor(
      config.getParameter("initialDimensionalParameter", math.random(min, max))
    )))
  end

  onNodeConnectionChange()

  message.setHandler("getDimensionalParameter", function()
      return storage.dimensionalParameter
    end)

  message.setHandler("setDimensionalParameter", function(_, _, value)
      storage.dimensionalParameter = value
    end)
end

function onInputNodeChange(args)
  -- When a switch object is broken, it will set its output to off and
  -- the connection will change. If the latter arrives first, the object
  -- will incorrectly shut itself off when the former arrives afterward.
  -- Therefore, treat all node changes as connection changes.
  onNodeConnectionChange(args)
end

function onNodeConnectionChange(args)
  if object.isInputNodeConnected(0) then
    storage.active = object.getInputNodeLevel(0)
  else
    storage.active = true
  end
  updateActive()
end

function updateActive()
  if storage.active then
    animator.setAnimationState("teleporter", "on")
  else
    animator.setAnimationState("teleporter", "off")
  end
  object.setInteractive(storage.active)
end
