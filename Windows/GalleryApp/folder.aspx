<%@ Page language="c#" Codebehind="folder.aspx.cs" AutoEventWireup="false" Inherits="GalleryApp.folder" %>
<%@ Reference Control="LabeledThumbnail.ascx"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>folder</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link rel="stylesheet" href="default.css">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<P>
				<asp:Label id="folder_name" runat="server">folder_name</asp:Label>
			</P>
			<P>
				<asp:Label id="folder_caption" runat="server">folder_caption</asp:Label>
			</P>
			<P>
				<asp:Panel id="thumbnails" runat="server" Height="400px" Width="560px">Panel 
				</asp:Panel>
			</P>
		</form>
	</body>
</HTML>
