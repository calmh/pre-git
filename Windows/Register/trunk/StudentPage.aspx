<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="StudentPage.aspx.cs"
    Inherits="StudentPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title>Hantera tränande</title>
</head>
<body>
    <form id="form1" runat="server">
    <h1>
        Hantera tränande</h1>
    <asp:Panel ID="messagePane" CssClass="section error" Visible="false" runat="server">
        <h2>
            Meddelande</h2>
        <p>
            <asp:Label ID="lMessage" runat="server" Text=""></asp:Label></p>
    </asp:Panel>
    <div class="section">
        <h2>
            <asp:Label ID="lHeader" runat="server" Text="Label"></asp:Label></h2>
        <div class="form">
            <table>
                <tr>
                    <td class="prompt">
                        Förnamn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbFName" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Efternamn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbSName" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Personnummer
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbPersonalID" runat="server" Width="200px"></asp:TextBox>
                        (YYYYMMDD, YYYYMMDD-XXXX eller blankt)
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Epostadress
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbEmail" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Telefonnummer (hem)
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbHomePhone" runat="server" Width="200px"></asp:TextBox>
                        (046-123456)
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Telefonnummer (mobil)
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbMobilePhone" runat="server" Width="200px"></asp:TextBox>
                        (0708-123456)
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Gatuadress
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbStreetAddress" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Postnummer
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbZipCode" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Postort
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbCity" runat="server" Width="200px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Grupp
                    </td>
                    <td class="value">
                        <asp:DropDownList ID="ddGroup" runat="server">
                        </asp:DropDownList>
                        <asp:TextBox ID="tbGroup" runat="server"></asp:TextBox>
                        Välj existerande eller ange namn på ny grupp.                        
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Titel
                    </td>
                    <td class="value">
                        <asp:DropDownList ID="ddTitle" runat="server">
                            <asp:ListItem Value="0">Okänt</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Toe Tai</asp:ListItem>
                            <asp:ListItem Value="2">Djo Gau</asp:ListItem>
                            <asp:ListItem Value="3">Gau Lin</asp:ListItem>
                            <asp:ListItem Value="4">Sifu</asp:ListItem>
                            <asp:ListItem Value="5">Annat</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Eget lösenord satt
                    </td>
                    <td class="value">
                        <asp:Label ID="lPersonalPassword" runat="server" Text="Nej"></asp:Label>
                        <asp:CheckBox ID="cbPersonalPassword" runat="server" Visible="false" />
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        E-postlistor
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbMailingLists" runat="server" Width="200px"></asp:TextBox>
                        Kommaseparerad lista.
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Kommentarer
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbComments" runat="server" TextMode="MultiLine" Columns="32" Rows="10"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        &nbsp;
                    </td>
                    <td class="value">
                        <asp:Button ID="bSave" runat="server" Text="Spara" OnClick="bSave_Click" />
                    </td>
                </tr>
                <asp:Panel ID="deletePanel" runat="server" Visible="false">
                    <tr>
                        <td class="prompt">
                            &nbsp;
                        </td>
                        <td>
                            <asp:CheckBox ID="cbDelete" runat="server" AutoPostBack="true" />
                            <asp:Button ID="bDelete" runat="server" Text="Radera" OnClick="bDelete_Click" />
                        </td>
                    </tr>
                </asp:Panel>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
