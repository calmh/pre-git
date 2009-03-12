<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminPage.aspx.cs" Inherits="AdminPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="section">
        <h2>
            Klubbrättigheter</h2>
        <div class="form">
            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" OnRowCommand="gvUsers_RowCommand">
                <RowStyle CssClass="tableRow" />
                <AlternatingRowStyle CssClass="tableAltRow" />
            </asp:GridView>
            <p>
                R &mdash; Se klubbmedlemmar och statistik.<br />
                E &mdash; Skapa och redigera klubbmedlemmar, skicka meddelanden.<br />
                G &mdash; Skapa och redigera graderingar.<br />
                P &mdash; Skapa och redigera inbetalningar.<br />
                X &mdash; Radera klubbmedlemmar.<br />
            </p>
        </div>
    </div>
    <div class="section">
        <h2>
            Ny klubb</h2>
        <div class="form">
            <table>
                <tr>
                    <td class="prompt">
                        Namn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbClubName" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        &nbsp;
                    </td>
                    <td class="value">
                        <asp:Button ID="bSaveClub" runat="server" Text="Lägg till" OnClick="bSaveClub_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="section">
        <h2>
            Ny användare</h2>
        <div class="form">
            <table>
                <tr>
                    <td class="prompt">
                        Användarnamn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbUserName" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Namn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbRealName" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Lösenord
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbPassword" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        &nbsp;
                    </td>
                    <td class="value">
                        <asp:Button ID="bSaveUser" runat="server" Text="Lägg till" OnClick="bSaveUser_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
