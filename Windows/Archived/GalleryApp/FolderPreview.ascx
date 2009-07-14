<%@ Control Language="c#" AutoEventWireup="false" Codebehind="FolderPreview.ascx.cs" Inherits="GalleryApp.FolderPreview" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<div class="folderPreview">
	<div class="spacer">&nbsp;</div>
	<div class="thumbnail">
		<a href="folder.aspx?id=<%=Folder.FriendlyID%>">
			<asp:Image id="thumbnail" runat="server"></asp:Image></a>
	</div>
	<div class="description">
			<p><a href="folder.aspx?id=<%=Folder.FriendlyID%>"><asp:Label id="name" runat="server" CssClass="folderName">Label</asp:Label></a></p>
			<p><asp:Label id="caption" runat="server" CssClass="folderCaption">Label</asp:Label></p>
	</div>
	<div class="spacer">&nbsp;</div>
</div>
