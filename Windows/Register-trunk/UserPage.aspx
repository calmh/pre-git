<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserPage.aspx.cs" Inherits="UserPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Uppdatera persondata</title>
    <link rel="Stylesheet" href="defaults.css" />
</head>
<body>
    <form id="form1" runat="server">
    <h1>Uppdatera persondata</h1>
    <asp:Panel ID="messagePane" CssClass="section" runat="server" Visible="false">
    <h2>Meddelande</h2>
        <asp:Label ID="lMessage" runat="server" Text="Label"></asp:Label>
    </asp:Panel>
    <asp:Panel ID="loginPane" CssClass="section" runat="server">
        <h2>
            Inloggning</h2>
        <table>
            <tr>
                <td class="prompt">
                    Klubb
                </td>
                <td class="value">
                    <asp:DropDownList ID="ddClubs" runat="server">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Efternamn
                </td>
                <td class="value">
                    <asp:TextBox ID="tbName" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Lösenord
                </td>
                <td class="value">
                    <asp:TextBox ID="tbPinCode" textmode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    &nbsp;
                </td>
                <td class="value">
                    <asp:Button ID="bLogIn" runat="server" Text="Logga in" OnClick="bLogIn_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="informationPane" CssClass="section" runat="server">
        <h2>
            Användarinformation</h2>
        <table>
            <tr>
                <td class="prompt">
                    Namn
                </td>
                <td class="value">
                    <asp:TextBox ID="tbNameRO" readonly="true" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Epostadress
                </td>
                <td class="value">
                    <asp:TextBox ID="tbEmail" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Telefonnummer (hem)
                </td>
                <td class="value">
                    <asp:TextBox ID="tbHomePhone" runat="server"></asp:TextBox>
                    (046-123456)
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Telefonnummer (mobil)
                </td>
                <td class="value">
                    <asp:TextBox ID="tbMobilePhone" runat="server"></asp:TextBox>
                    (0708-123456)
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Gatuadress
                </td>
                <td class="value">
                    <asp:TextBox ID="tbStreetAddress" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Postnummer
                </td>
                <td class="value">
                    <asp:TextBox ID="tbZipCode" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Postort
                </td>
                <td class="value">
                    <asp:TextBox ID="tbCity" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Nytt lösenord
                </td>
                <td class="value">
                    <asp:TextBox ID="tbPass1" textmode="Password" runat="server"></asp:TextBox>
                    Lämna blankt för att inte ändra.
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Nytt lösenord (igen)
                </td>
                <td class="value">
                    <asp:TextBox ID="tbPass2" textmode="Password" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    &nbsp;
                </td>
                <td class="value">
                    <asp:Button ID="bSave" runat="server" Text="Spara" OnClick="bSave_Click" />
                    <asp:Button ID="bLogOut" runat="server" Text="Logga ut" OnClick="bLogOut_Click" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    </form>
</body>
</html>
