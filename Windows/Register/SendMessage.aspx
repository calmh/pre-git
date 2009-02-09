<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SendMessage.aspx.cs" Inherits="SendMessage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Skicka meddelande</title>
    <link rel="Stylesheet" href="defaults.css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="section">
        <h2>
            Skicka till...</h2>
        <table>
            <tr>
                <td class="prompt">
                    <asp:RadioButton ID="rbEmail" runat="server" GroupName="messageDestination" />Epostmottagare:
                </td>
                <td class="value">
                    <asp:Label ID="lToEmail" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    <asp:RadioButton ID="rbMobile" runat="server" GroupName="messageDestination" />SMS-mottagare:
                </td>
                <td class="value">
                    <asp:Label ID="lToMobile" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    &nbsp;
                </td>
                <td class="value">
                    <asp:Button ID="bContinue" runat="server" Text="Fortsätt..." 
                        onclick="bContinue_Click" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
