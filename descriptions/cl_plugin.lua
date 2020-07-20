net.Receive("nutOpenDetailedDescriptions", function()
	local entity = net.ReadEntity()
	local URL = net.ReadString()
	local description = net.ReadString()
	
	local Frame = vgui.Create("DFrame")
	Frame:Center()
	Frame:SetPos(Frame:GetPos() - 150, 250, 0)
	Frame:SetSize(350, 500)
	Frame:SetTitle("Detailed Description - " .. entity:GetName())
	Frame:MakePopup()

	local List = vgui.Create("DListView", Frame)
	List:Dock( FILL )
	List:DockMargin( 0, 0, 0, 5 )
	List:SetMultiSelect(false)
	
	local textEntry = vgui.Create("DTextEntry", List)
	textEntry:Dock( FILL )
	textEntry:DockMargin( 0, 0, 0, 0 )
	textEntry:SetMultiline(true)
	textEntry:SetVerticalScrollbarEnabled(true)
	
	if (description) then
		textEntry:SetText(description)
	end
	
	local DButton = vgui.Create("DButton", List)
	DButton:Dock( BOTTOM )
	DButton:SetText("View Reference Picture")
	DButton:DockMargin( 0, 0, 0, 0 )
	
	DButton.DoClick = function()
		gui.OpenURL(URL)
	end
end)

net.Receive("nutSetDetailedDescriptions", function()
	local client = net.ReadEntity()
	
	local Frame = vgui.Create("DFrame")
	Frame:Center()
	Frame:SetPos(Frame:GetPos() - 150, 250, 0)
	Frame:SetSize(350, 500)
	Frame:SetTitle("Edit Detailed Description")
	Frame:MakePopup()

	local List = vgui.Create("DListView", Frame)
	List:Dock( FILL )
	List:DockMargin( 0, 0, 0, 5 )
	List:SetMultiSelect(false)
	
	local textEntry = vgui.Create("DTextEntry", List)
	textEntry:Dock( FILL )
	textEntry:DockMargin( 0, 0, 0, 0 )
	textEntry:SetMultiline(true)
	textEntry:SetVerticalScrollbarEnabled(true)
	
	if (LocalPlayer():getChar():getData("textDetDescData")) then
		textEntry:SetText(LocalPlayer():getChar():getData("textDetDescData"))
	end
	
	local DButton = vgui.Create("DButton", List)
	DButton:Dock( BOTTOM )
	DButton:SetText("Edit")
	DButton:DockMargin( 0, 0, 0, 0 )
	
	local URL = vgui.Create("DTextEntry", List)
	URL:Dock( BOTTOM )
	URL:DockMargin( 0, 0, 0, 0 )
	URL:SetValue("Reference Image URL")
	
	if (LocalPlayer():getChar():getData("textDetDescDataURL")) then
		URL:SetValue(LocalPlayer():getChar():getData("textDetDescDataURL"))
		URL:SetText(LocalPlayer():getChar():getData("textDetDescDataURL"))
	end
	
	DButton.DoClick = function()
		net.Start("nutModifyDetailedDescriptions")
			net.WriteEntity(client)
			net.WriteString(URL:GetValue())
			net.WriteString(textEntry:GetValue())
		net.SendToServer()
		Frame:Remove()
	end
end)