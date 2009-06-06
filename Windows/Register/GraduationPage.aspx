<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="GraduationPage.aspx.cs"
    Inherits="GraduationPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title>Hantera graderingar</title>
</head>
<body>
    <form id="form1" runat="server">
    <h1>
        Hantera graderingar</h1>
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
            Registrerade graderingar</h2>
        <asp:GridView ID="gvGraduations" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="When" DataFormatString="{0:yyyy-MM-dd}" HeaderText="Datum" />
                <asp:BoundField DataField="GradeStr" HeaderText="Grad" />
                <asp:BoundField DataField="Instructor" HeaderText="Instruktör" />
                <asp:BoundField DataField="Examiner" HeaderText="Examinator" />
            </Columns>
            <RowStyle CssClass="tableRow" />
            <AlternatingRowStyle CssClass="tableAltRow" />
        </asp:GridView>
    </div>
    <div class="section">
        <h2>
            Registrera ny gradering</h2>
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
                        <asp:Button ID="lbChangeDateSelector" runat="server" 
                            onclick="lbChangeDateSelector_Click" Text="Button" />
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Grad
                    </td>
                    <td class="value">
                        <asp:DropDownList ID="ddGrade" runat="server">
                            <asp:ListItem Value="-8">Jun. Röd</asp:ListItem>
                            <asp:ListItem Value="-7">Jun. Gul</asp:ListItem>
                            <asp:ListItem Value="-6">Jun. Grön</asp:ListItem>
                            <asp:ListItem Value="-5">Jun. Blå</asp:ListItem>
                            <asp:ListItem Value="-4">Jun. Svart</asp:ListItem>
                            <asp:ListItem Value="-3">Jun. Silver I</asp:ListItem>
                            <asp:ListItem Value="-2">Jun. Silver II</asp:ListItem>
                            <asp:ListItem Value="-1">Jun. Silver III</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Röd I</asp:ListItem>
                            <asp:ListItem Value="2">Röd II</asp:ListItem>
                            <asp:ListItem Value="3">Gul I</asp:ListItem>
                            <asp:ListItem Value="4">Gul II</asp:ListItem>
                            <asp:ListItem Value="5">Grön I</asp:ListItem>
                            <asp:ListItem Value="6">Grön II</asp:ListItem>
                            <asp:ListItem Value="7">Blå I</asp:ListItem>
                            <asp:ListItem Value="8">Blå II</asp:ListItem>
                            <asp:ListItem Value="9">Svart I</asp:ListItem>
                            <asp:ListItem Value="10">Svart II</asp:ListItem>
                            <asp:ListItem Value="11">Svart III</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Examinator
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbExaminer" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        Instruktör
                    </td>
                    <td class="value">
                        <asp:TextBox ID="tbInstructor" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="prompt">
                        &nbsp;
                    </td>
                    <td class="value">
                        <asp:Button ID="bSave" runat="server" Text="Registrera gradering" OnClick="bSave_Click" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
