local _, _, _, interfaceVersion = GetBuildInfo()

-- Polyfill C_Timer for clients that don't have it
-- Guaranteed not to have it: Wotlk client (30300)
if not C_Timer then
    C_Timer = {}
    function C_Timer.NewTicker(interval, callback)
        local f = CreateFrame("Frame")
        f.elapsed = 0
        f:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            if self.elapsed >= interval then
                self.elapsed = self.elapsed - interval
                callback()
            end
        end)
        return { Cancel = function() f:SetScript("OnUpdate", nil) end }
    end
end