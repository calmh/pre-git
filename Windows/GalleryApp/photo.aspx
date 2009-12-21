<%@ Page language="c#" Codebehind="photo.aspx.cs" AutoEventWireup="false" Inherits="GalleryApp.photo" %>
<%@ Register TagPrefix="uc1" TagName="LabeledPhoto" Src="LabeledPhoto.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>photo</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link rel="stylesheet" href="Default.css">
	</HEAD>
	<body MS_POSITIONING="GridLayout">
		<form id="Form1" method="post" runat="server">
			<uc1:LabeledPhoto id="labeled_photo" runat="server"></uc1:LabeledPhoto>
		</form>
	</body>
</HTML>
