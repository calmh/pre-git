<%@ Control Language="c#" AutoEventWireup="false" Codebehind="LabeledThumbnail.ascx.cs" Inherits="GalleryApp.LabeledThumbnail" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<asp:Panel id="thumbnail_panel" runat="server" CssClass="thumbnail_panel">
<a href="photo.aspx?id=<%=Photo.FriendlyID.ToString()%>">
	<asp:Image id="thumbnail_image" runat="server"></asp:Image>
	<BR>
	<asp:Label id="thumbnail_label" runat="server">Label</asp:Label>
</a>
</asp:Panel>
