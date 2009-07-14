<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="Default.aspx.cs"
    Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title>Startsida</title>
</head>
<body>
    <form id="form1" runat="server">
    <h1>
        T.I.A. Registersystem</h1>
    <div>
        <p>
            <asp:Label ID="lMessage" runat="server" Text="" Font-Bold="true"></asp:Label></p>
    </div>
    <div class="section">
        <h2>
            Klubbar</h2>
        <p>
            Du har tillgång till registerdata för nedanstående klubbar.
        </p>
        <asp:GridView ID="gvClubs" runat="server" AutoGenerateColumns="False" OnRowCommand="gvClubs_RowCommand"
            BorderWidth="0" GridLines="None" CellSpacing="-1" DataKeyNames="ID" EnableViewState="false" EnableTheming="false">
            <Columns>
            <asp:ButtonField ButtonType="Image" ImageUrl="edit-16x16.png" CommandName="Klubb" />
                <asp:BoundField DataField="Name" HeaderText="Klubb" />
                <asp:BoundField DataField="TotalStudents" HeaderText="Medlemmar" />
                <asp:BoundField DataField="ActiveStudents" HeaderText="Aktiva" />
            </Columns>
            <RowStyle CssClass="tableRow" />
            <AlternatingRowStyle CssClass="tableAltRow" />
        </asp:GridView>
        <p>
            <asp:Label ID="lAdmin" runat="server" Text=""></asp:Label><br />
            <asp:HyperLink ID="hlAdmin" runat="server"></asp:HyperLink>
        </p>
    </div>
    <div class="section">
        <h2>
            Ditt konto</h2>
        <div class="form">
            <table>
                <tr>
                    <td class="prompt">
                        Användarnamn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbLogin" runat="server" ReadOnly="true"></asp:TextBox>
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
                        Nytt lösenord
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbPass1" runat="server" TextMode="Password"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Nytt lösenord (igen)
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbPass2" runat="server" TextMode="Password"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Nuvarande lösenord
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbPass" runat="server" TextMode="Password"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        &nbsp;
                    </td>
                    <td class="value">
                        <asp:Button ID="bUpdateAccount" runat="server" Text="Uppdatera konto" OnClick="bUpdateAccount_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
