<%@ Page language="c#" Codebehind="login.aspx.cs" AutoEventWireup="false" Inherits="GalleryApp.login" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML>
	<HEAD>
		<title>login</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link rel="stylesheet" href="Default.css">
	</HEAD>
	<body>
		<h1>Log in</h1>
		<form id="Form1" method="post" runat="server">
			<div class="loginForm">
				<div class="message">
				<asp:Label id="message" runat="server">Enter your user details to log in.</asp:Label>
				</div>
				<div class="row">
					<span class="rowLeft">Name:</span> <span class="rowRight">
						<asp:TextBox id="name" runat="server"></asp:TextBox></span>
				</div>
				<div class="row">
					<span class="rowLeft">Password:</span> <span class="rowRight">
						<asp:TextBox id="password" runat="server" TextMode="Password"></asp:TextBox></span>
				</div>
				<div class="row">
					<span class="rowLeft">&nbsp;</span> <span class="rowRight">
						<asp:Button id="button" runat="server" Text="Log in"></asp:Button></span>
				</div>
				&nbsp;
			</div>
		</form>
	</body>
</HTML>
