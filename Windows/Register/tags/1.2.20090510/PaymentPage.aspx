<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="PaymentPage.aspx.cs"
    Inherits="PaymentPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title>Hantera inbetalningar</title>
</head>
<body>
    <form id="form1" runat="server">
    <h1>
        Hantera inbetalningar</h1>
    <div class="section">
        <h2>
            Persondata</h2>
        <div class="form">
            <table>
                <tr>
                    <td class="prompt">
                        Förnamn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbFName" runat="server" ReadOnly="true"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Efternamn
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbSName" runat="server" ReadOnly="true"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Personnummer
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbPersonalID" runat="server" ReadOnly="true"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="section">
        <h2>
            Registrerade betalningar</h2>
        <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" OnRowCancelingEdit="gvPayments_RowCancelingEdit"
            OnRowEditing="gvPayments_RowEditing" OnRowUpdating="gvPayments_RowUpdating">
            <Columns>
                <asp:BoundField DataField="When" DataFormatString="{0:yyyy-MM-dd}" HeaderText="Datum" ApplyFormatInEditMode="true"/>
                <asp:BoundField DataField="Amount" DataFormatString="{0:F2}" HeaderText="Belopp" />
                <asp:BoundField DataField="Comment" HeaderText="Avser" />
                <asp:CommandField EditText="Redigera" ShowEditButton="true" UpdateText="Spara" CancelText="Avbryt" />
            </Columns>
            <RowStyle CssClass="tableRow" />
            <AlternatingRowStyle CssClass="tableAltRow" />
        </asp:GridView>
    </div>
    <div class="section">
        <h2>
            Registrera ny inbetalning</h2>
        <div class="form">
            <table>
                <tr>
                    <td class="prompt">
                        Datum
                    </td>
                    <td class="value">
                        <asp:Calendar ID="calWhen" runat="server" BackColor="White" BorderColor="#999999"
                            CellPadding="4" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt"
                            ForeColor="Black" Height="180px" Width="200px" FirstDayOfWeek="Monday">
                            <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                            <SelectorStyle BackColor="#CCCCCC" />
                            <WeekendDayStyle BackColor="#FFFFCC" />
                            <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                            <OtherMonthDayStyle ForeColor="#808080" />
                            <NextPrevStyle VerticalAlign="Bottom" />
                            <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                            <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                        </asp:Calendar>
                        <asp:TextBox ID="tbWhen" runat="server"></asp:TextBox>
                        <asp:Button ID="lbChangeDateSelector" runat="server" OnClick="lbChangeDateSelector_Click"
                            Text="Button" />
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Belopp
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbAmount" runat="server"></asp:TextBox>
                        (0000.00)
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Avser
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbComment" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        &nbsp;
                    </td>
                    <td class="value">
                        <asp:Button ID="bSave" runat="server" Text="Lägg till betalning" OnClick="bSave_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
