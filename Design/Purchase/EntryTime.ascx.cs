using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Design_Purchase_EntryTime : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public void setCurrentTime()
    {
        int HR = System.DateTime.Now.Hour;

        if (HR > 11)
        {


            cmbAMPM2.SelectedIndex = cmbAMPM2.Items.IndexOf(cmbAMPM2.Items.FindByText("PM"));
            if (HR == 12)
            {
                ddlHr.SelectedIndex = ddlHr.Items.IndexOf(ddlHr.Items.FindByText(Util.GetString(12)));
            }
            else
            {
                ddlHr.SelectedIndex = ddlHr.Items.IndexOf(ddlHr.Items.FindByText(Util.GetString(HR - 12)));
            }
            ddlMin.SelectedIndex = ddlMin.Items.IndexOf(ddlMin.Items.FindByText(Util.GetString(System.DateTime.Now.Minute)));

        }
        else
        {
            cmbAMPM2.SelectedIndex = cmbAMPM2.Items.IndexOf(cmbAMPM2.Items.FindByText("AM"));
            ddlHr.SelectedIndex = ddlHr.Items.IndexOf(ddlHr.Items.FindByText(Util.GetString(HR)));
            ddlMin.SelectedIndex = ddlMin.Items.IndexOf(ddlMin.Items.FindByText(Util.GetString(System.DateTime.Now.Minute)));
        }


    }

    public string GetTimeForDataBase()
    {
        if ((ddlHr.SelectedValue != "-") && (ddlMin.SelectedValue != "-") && (cmbAMPM2.SelectedValue != "-"))
        {
            if (cmbAMPM2.SelectedValue == "AM")
                return (ddlHr.SelectedValue + ":" + ddlMin.SelectedValue + ":00");
            else
            {
                if (Util.GetInt(ddlHr.SelectedValue) == 12)
                {
                    return ((Util.GetInt(ddlHr.SelectedValue)) + ":" + ddlMin.SelectedValue + ":00");
                }
                else
                {
                    return ((Util.GetInt(ddlHr.SelectedValue) + 12) + ":" + ddlMin.SelectedValue + ":00");
                }
            }
        }
        else
            return string.Empty;
    }
    public string GetTimeForDisplay()
    {
        if ((ddlHr.SelectedValue != "-") && (ddlMin.SelectedValue != "-") && (cmbAMPM2.SelectedValue != "-"))
            return (ddlHr.SelectedValue + ":" + ddlMin.SelectedItem.Text + cmbAMPM2.SelectedValue);
        else
            return string.Empty;
        
    }
    
    public void SetTime(int hh, int mm, string AMPM)
    {
        ddlHr.SelectedIndex = ddlHr.Items.IndexOf(ddlHr.Items.FindByText(Util.GetString(hh)));
        ddlMin.SelectedIndex = ddlMin.Items.IndexOf(ddlMin.Items.FindByText(Util.GetString(mm)));
        cmbAMPM2.SelectedIndex = cmbAMPM2.Items.IndexOf(cmbAMPM2.Items.FindByText(AMPM));
    
    }
    public int TabIndex
    {
        set {
            ddlHr.TabIndex = Util.GetShortInt(value);
            ddlMin.TabIndex = Util.GetShortInt(value);
            cmbAMPM2.TabIndex = Util.GetShortInt(value); 
        }
    }
    public void SetFocus()
    {
        ddlHr.Focus();
    }
}
