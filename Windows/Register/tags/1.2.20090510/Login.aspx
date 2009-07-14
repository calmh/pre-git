<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title>Logga in</title>
</head>
<body>
    <form id="form1" runat="server">
    <h1>
        Logga in</h1>
        <p>
            <asp:Label ID="lMessage" runat="server" Text=""></asp:Label>
        </p>
    <div class="section" style="max-width: 400px">
    <h2>För tränande</h2>
    <p>
    Detta är medlemsregistersystemet för T.I.A. 
    Om du i är tränande och vill logga in för att redigera dina personuppgifter kan du gå tillsidan  <a href="UserPage.aspx">"uppdatera persondata"</a>.
    </p>
    </div>
    <div class="section" style="max-width: 400px">
    <h2>För administratörer</h2>
    <p>
    Om du har administrativ tillgång till registret kan du ange dina uppgifter här för att logga in.
    </p>
        <table>
            <tr>
                <td class="prompt">
                    Användarnamn
                </td>
                <td class="value">
                    <asp:TextBox ID="tbUser" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    Lösenord
                </td>
                <td class="value">
                    <asp:TextBox ID="tbPassword" runat="server" TextMode="Password"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="prompt">
                    &nbsp;
                </td>
                <td class="value">
                    <asp:Button id="bLogin" Text="Logga in" runat="server" onclick="Unnamed1_Click"/>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
