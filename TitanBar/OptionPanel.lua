-- OptionPanel.lua
-- written by Habna


plugin.GetOptionsPanel = function( self )
	local optPanel = Turbine.UI.Control();

	local optLabel = Turbine.UI.Label();
	optLabel:SetParent( optPanel );
	optLabel:SetText( L["TBOpt"] );
	optLabel:SetSize( optLabel:GetTextLength() * 9, 30 );
	optLabel:SetForeColor( Color["green"] );

	return optPanel
end