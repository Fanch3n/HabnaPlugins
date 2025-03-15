-- Written by Garan

import "Turbine.UI";
import "Turbine.UI.Lotro";

FontMetric = class(Turbine.UI.Label);

function FontMetric:Constructor()
	Turbine.UI.Control.Constructor(self);

	self.Text=Turbine.UI.Label();
	self.Text:SetParent(self);

	self.VScroll=Turbine.UI.Lotro.ScrollBar();
	self.VScroll:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.VScroll:SetParent(self);
	self.Text:SetVerticalScrollBar(self.VScroll);

	self.HScroll=Turbine.UI.Lotro.ScrollBar();
	self.HScroll:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.HScroll:SetParent(self);
	self.Text:SetHorizontalScrollBar(self.HScroll);

	self.fontHeight=12;
	self.fontHeights = {
		[Turbine.UI.Lotro.Font.Arial12] = 12,
		[Turbine.UI.Lotro.Font.TrajanPro13] = 13,
		[Turbine.UI.Lotro.Font.TrajanPro14] = 14,
		[Turbine.UI.Lotro.Font.TrajanPro15] = 15,
		[Turbine.UI.Lotro.Font.TrajanPro16] = 16,
		[Turbine.UI.Lotro.Font.TrajanPro18] = 18,
		[Turbine.UI.Lotro.Font.TrajanPro19] = 19,
		[Turbine.UI.Lotro.Font.TrajanPro20] = 20,
		[Turbine.UI.Lotro.Font.TrajanPro21] = 21,
		[Turbine.UI.Lotro.Font.TrajanPro23] = 23,
		[Turbine.UI.Lotro.Font.TrajanPro24] = 24,
		[Turbine.UI.Lotro.Font.TrajanPro25] = 25,
		[Turbine.UI.Lotro.Font.TrajanPro26] = 26,
		[Turbine.UI.Lotro.Font.TrajanPro28] = 28,
		[Turbine.UI.Lotro.Font.TrajanProBold16] = 16,
		[Turbine.UI.Lotro.Font.TrajanProBold22] = 22,
		[Turbine.UI.Lotro.Font.TrajanProBold24] = 24,
		[Turbine.UI.Lotro.Font.TrajanProBold25] = 25,
		[Turbine.UI.Lotro.Font.TrajanProBold30] = 30,
		[Turbine.UI.Lotro.Font.TrajanProBold36] = 36,
		[Turbine.UI.Lotro.Font.Verdana10] = 10,
		[Turbine.UI.Lotro.Font.Verdana12] = 12,
		[Turbine.UI.Lotro.Font.Verdana14] = 14,
		[Turbine.UI.Lotro.Font.Verdana16] = 16,
		[Turbine.UI.Lotro.Font.Verdana18] = 18,
		[Turbine.UI.Lotro.Font.Verdana20] = 20,
		[Turbine.UI.Lotro.Font.Verdana22] = 22,
		[Turbine.UI.Lotro.Font.Verdana23] = 23,
		[0x42000021] = 12,
		[0x4200000e] = 20,
		[0x4200000f] = 22,
		[0x42000010] = 24,
		[0x4200002b] = 14
	}
end

function FontMetric:SetFont(font)
	self.Text:SetFont(font);
	self.fontHeight = self.fontHeights[font] or 12 -- Default to 12
end

function FontMetric:GetTextWidth(text, height)
	height = height or self.fontHeight;
	self.Text:SetHeight(height);
	self.Text:SetMultiline(false);

	local width = string.len(text);
	self.Text:SetText(text);
	self.Text:SetWidth(width);

	while self.HScroll:IsVisible() do
		width = width + 1;
		self.Text:SetWidth(width);
	end

	return width;
end

function FontMetric:GetTextHeight(text, width)
	if width then
		self.Text:SetWidth(width);
	end

	self.Text:SetMultiline(true);
	local height = self.fontHeight;
	self.Text:SetText(text);
	self.Text:SetHeight(height);

	while self.HScroll:IsVisible() or self.VScroll:IsVisible() do
		height = height + 1;
		self.Text:SetHeight(height);
	end

	return height;
end