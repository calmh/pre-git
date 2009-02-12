﻿<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true" CodeFile="ClubPage.aspx.cs"
    Inherits="ClubPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="Stylesheet" href="defaults.css" />
    <title>Klubbsida</title>
</head>
<body>
    <form id="form1" runat="server">
    <h1 class="noprint">
        Klubbsida,
        <asp:Label ID="clubName" runat="server" Text="Label"></asp:Label></h1>
    <div class="section">
        <h2>
            Medlemsregister</h2>
        <div class="noprint" style="margin-bottom: 10px;">
            <asp:Button ID="lbExportCSV" runat="server" Text="Exportera som CSV" OnCommand="commandClicked"
                CommandName="CSV" />
            <asp:Button ID="lbNew" runat="server" Text="Registrera ny tränande" OnCommand="commandClicked"
                CommandName="Ny" />
        </div>
        <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="False" OnRowCommand="gvStudents_RowCommand"
            OnRowDataBound="gvStudents_RowDataBound" OnSorting="gvStudents_Sorting" DataKeyNames="ID"
            EnableTheming="False" GridLines="None" CellSpacing="-1" AllowSorting="True" EnableViewState="false">
            <RowStyle CssClass="tableRow" />
            <AlternatingRowStyle CssClass="tableAltRow" />
        </asp:GridView>
        <p class="noprint">
            <asp:CheckBox ID="cbFilterActive" runat="server" OnCheckedChanged="cbFilterActive_CheckedChanged" AutoPostBack="true" />Visa
            endast aktiva elever
            </p>
        <div class="noprint" style="margin-top: 10px; margin-bottom: 10px;">
            <b>Markering:</b>
            <asp:Button ID="lbEraseSelection" OnCommand="commandClicked" CommandName="EraseSelection"
                runat="server" Text="Rensa" />
            <asp:Button ID="lbSelectedGradering" OnCommand="commandClicked" CommandName="SelectedAddGraduation"
                runat="server" Text="Registrera gradering" />
            <asp:Button ID="lbSelectedMessage" OnCommand="commandClicked" CommandName="SelectedSendMessage"
                runat="server" Text="Skicka meddelande" />
        </div>
        <p class="noprint">
            Elever betraktas som "aktiva" om det finns en registrerad inbetalning de senaste
            12 månaderna. För elever där senaste inbetalning är mer än sex månader sedan markeras
            detta med gul bakgrundsfärg.
        </p>
    </div>
    <div class="section">
        <h2>
            Statistik</h2>
        <div class="floater">
            <h3>
                Medlemmar</h3>
            <asp:Table ID="tabStatistics" runat="server">
            </asp:Table>
            <p class="noprint">
                Statistiken baserar sig på de aktiva elever i medlemsregistret som har ett personnummer.
            </p>
        </div>
        <div class="floater">
            <h3>
                Inbetalningar</h3>
            <asp:Table ID="tabPayments" runat="server">
            </asp:Table>
            <p class="noprint">
                Summerade inbetalningar är de som bokförts de senaste 12 månaderna, uppdelat per
                märkning.
            </p>
        </div>
    </div>
    </form>
</body>
</html>