using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Lab_labobservation_Help : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            BindInvestigation();
            BindHelp();
        }
    }
    private void BindInvestigation()
    {
        string str= @"SELECT lom.LabObservation_ID,lom.Name  FROM labobservation_investigation loi INNER JOIN labobservation_master lom 
        ON loi.labobservation_id=lom.labobservation_id WHERE  loi.Child_Flag<>1";

    //    string str = "SELECT NAME,LabObservation_ID FROM labobservation_master WHERE NAME<>'' order by NAME";
        DataTable dt = StockReports.GetDataTable(str);
        ddlobservation.DataSource = dt;
        ddlobservation.DataTextField = "Name";
        ddlobservation.DataValueField = "LabObservation_ID";
        ddlobservation.DataBind();
        ddlobservation.Items.Insert(0, "Select Observation");



    }
    private void BindHelp()
    {
        string str = "SELECT ID,Concat('','#',HELP)HELP FROM labobservation_help_master order by HELP";
        DataTable dt = StockReports.GetDataTable(str);
        ListBox1.DataTextField = "HELP";
        ListBox1.DataValueField = "ID";
        ListBox1.DataSource = dt;
        ListBox1.DataBind();
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (ddlobservation.SelectedItem.Value != "Select Observation")
        {
                foreach (ListItem li in ListBox1.Items)
                {
                    if (li.Selected)
                    {

                        string str = "DELETE FROM LabObservation_Help where LabObservation_ID='" + ddlobservation.SelectedItem.Value + "' and HelpId = '" + li.Value + "' ";
                        StockReports.ExecuteDML(str);

                        str = "INSERT INTO LabObservation_Help(LabObservation_ID,HelpId) values('" + ddlobservation.SelectedItem.Value + "','" + li.Value + "')";

                        StockReports.ExecuteDML(str);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
                      //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                    }
                }

                bindMapping();
                ListBox1.SelectedIndex = 0;
            }
        
        else
        {
            //lblMsg.Text = "Please Select The Observation";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select The Observation');", true);
            ddlobservation.Focus();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from labobservation_help_master where HELP='" + txtHelp.Text + "'"));
        if (count > 0)
        {
           // lblMsg.Text = "Help Already In The List";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Help Already In The List');", true);
            txtHelp.Text = "";
            return;
        }
        else
        {
            string str = "INSERT INTO labobservation_help_master(HELP) VALUES('" + txtHelp.Text.Trim() + "')";
            StockReports.ExecuteDML(str);
            BindHelp();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            txtHelp.Text = "";
        }

    }
    protected void ddlobservation_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindMapping();
    }

    private void bindMapping()
    {
        string str = "SELECT '" + ddlobservation.SelectedItem.Text + "'name,loh.id,lhm.Help FROM LabObservation_Help loh INNER JOIN labobservation_master lom " +
                     "ON loh.LabObservation_id=lom.LabObservation_ID INNER JOIN LabObservation_Help_Master lhm " +
                     "ON lhm.id=loh.HelpId AND loh.LabObservation_id='" + ddlobservation.SelectedValue + "'";
        DataTable dt = StockReports.GetDataTable(str);
        grdObs.DataSource = dt;
        grdObs.DataBind();


    }
    //protected void btnEdit_Click(object sender, EventArgs e)
    //{
    //    try
    //    {

    //        pnlEdit.Visible=true;

    //        txtEdit.Text = ListBox1.SelectedItem.Text;


    //    }
    //    catch
    //    {
    //      //  lblMsg.Text = "Please Select List";
    //        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select List');", true);
    //        pnlEdit.Visible=false;
    //    }

    //}

    protected void grdObs_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            string id = ((Label)grdObs.Rows[args].FindControl("lblid")).Text;
            string str1 = "DELETE FROM LabObservation_Help where id='" + id + "' ";
            StockReports.ExecuteDML(str1);

            bindMapping();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Deleted Successfully');", true);
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void btnEditUpdate_Click(object sender, EventArgs e)
    {
        string str = "UPDATE  labobservation_help_master set HELP ='" + txtEdit.Text.Trim() + "' where id=" + ListBox1.SelectedItem.Value + " ";
        StockReports.ExecuteDML(str);

        BindHelp();

        bindMapping();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Updated Successfully');", true);
        // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
    }

}
