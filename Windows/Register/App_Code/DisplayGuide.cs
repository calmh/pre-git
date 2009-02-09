using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for DisplayGuide
/// </summary>
public class DisplayGuide
{
    public bool IsCommand = false;
    public string CommandName = "";
    public string DataTextField = "";
    public string HeaderText = "";
    public string Align = "left";

    public DisplayGuide(string headerText, string dataTextField)
    {
        HeaderText = headerText;
        DataTextField = dataTextField;
    }

    public DisplayGuide(string headerText, string dataTextField, string align)
    {
        HeaderText = headerText;
        DataTextField = dataTextField;
        Align = align;
    }

    public DisplayGuide(string headerText, string dataTextField, string align, string commandName)
    {
        HeaderText = headerText;
        DataTextField = dataTextField;
        CommandName = commandName;
        IsCommand = true;
        Align = align;
    }

    public DataControlField GenerateField()
    {
        if (IsCommand)
        {
            ButtonField bf = new ButtonField();
            bf.HeaderText = HeaderText;
            bf.DataTextField = DataTextField;
            bf.CommandName = CommandName;
            bf.SortExpression = DataTextField;
            if (Align.ToLower() == "right")
            {
                bf.ItemStyle.CssClass = "rightAlign";
            }
            return bf;
        }
        else
        {
            BoundField bf = new BoundField();
            bf.HeaderText = HeaderText;
            bf.DataField = DataTextField;
            bf.SortExpression = DataTextField;
            if (Align.ToLower() == "right")
            {
                bf.ItemStyle.CssClass = "rightAlign";
            }
            return bf;
        }
    }
}
