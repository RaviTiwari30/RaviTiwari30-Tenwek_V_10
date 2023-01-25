using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_ActivateItem : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlPanel.SelectedValue == "SELECT")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }
        int isChecked = 0;
        foreach (ListItem li in chkDocuments.Items)
        {
            if (li.Selected)
                isChecked = 1;
        }
        if (isChecked == 0)
        {
            lblMsg.Text = "Please Select Documents";
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Update f_paneldocumentdetail Set IsActive=0, ");
            sb.Append("UpdatedBy='" + Util.GetString(Session["ID"]) + "',");
            sb.Append("UpdateDatetime=now() ");
            sb.Append("where PanelID=" + ddlPanel.SelectedValue + " ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            foreach (ListItem li in chkDocuments.Items)
            {
                if (li.Selected)
                {
                    sb = new StringBuilder();
                    sb.Append("Insert into f_paneldocumentdetail(DocumentID,PanelID,CreatedBy)");
                    sb.Append("values(" + li.Value + "," + ddlPanel.SelectedValue + ",'" + Util.GetString(Session["ID"]) + "')");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
            }
            foreach (ListItem lip in chkPanel2.Items)
            {
                if (lip.Selected)
                {
                    sb = new StringBuilder();
                    sb.Append("Insert into f_paneldocumentdetail(DocumentID,PanelID,CreatedBy)");
                    sb.Append("Select DocumentID," + lip.Value + ",'" + Util.GetString(Session["ID"]) + "' ");
                    sb.Append("from f_paneldocumentdetail Where PanelID=" + ddlPanel.SelectedValue + " ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
            }
            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSaveDoc_Click(object sender, EventArgs e)
    {
        if (txtNewDoc.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter New Document Name";
        }
        else
        {
            string s = "insert into f_paneldocumentmaster(Document,CreatorID) values('" + txtNewDoc.Text.Trim() + "','" + Util.GetString(Session["ID"]) + "')";
            StockReports.ExecuteDML(s);

            LoadDocument();
            LoadDocumentDetail();
            txtNewDoc.Text = "";
        }
    }

    protected void btnSavePanel_Click(object sender, EventArgs e)
    {
        if (ddlPanel.SelectedValue == "SELECT")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }

        int isChecked = 0;
        foreach (ListItem li in chkDocuments.Items)
        {
            if (li.Selected)
                isChecked = 1;
        }

        if (isChecked == 0)
        {
            lblMsg.Text = "Please Select Documents";
            return;
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Update f_paneldocumentdetail Set IsActive=0, ");
            sb.Append("UpdatedBy='" + Util.GetString(Session["ID"]) + "',");
            sb.Append("UpdateDatetime=now() ");
            sb.Append("where PanelID=" + ddlPanel.SelectedValue + " ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            foreach (ListItem li in chkDocuments.Items)
            {
                if (li.Selected)
                {
                    sb = new StringBuilder();
                    sb.Append("Insert into f_paneldocumentdetail(DocumentID,PanelID,CreatedBy)");
                    sb.Append("values(" + li.Value + "," + ddlPanel.SelectedValue + ",'" + Util.GetString(Session["ID"]) + "')");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
            }

            foreach (ListItem lip in chkPanel2.Items)
            {
                if (lip.Selected)
                {
                    sb = new StringBuilder();
                    sb.Append("Insert into f_paneldocumentdetail(DocumentID,PanelID,CreatedBy)");
                    sb.Append("Select DocumentID," + lip.Value + ",'" + Util.GetString(Session["ID"]) + "' ");
                    sb.Append("from f_paneldocumentdetail Where PanelID=" + ddlPanel.SelectedValue + " ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
            }
            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void chkSelect_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelect.Checked)
        {
            foreach (ListItem li in chkDocuments.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            foreach (ListItem li in chkDocuments.Items)
            {
                li.Selected = false;
            }
        }
    }

    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        chkSelect.Checked = false;
        LoadDocument();
        LoadDocumentDetail();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPanel();
            LoadDocument();
            LoadDocumentDetail();
        }

        UpdatePanelForDocuments();
        lblMsg.Text = "";
    }

    private void LoadDocument()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pdm.DocumentID,pdm.Document ");
        sb.Append("FROM f_paneldocumentmaster pdm WHERE  pdm.IsActive order by pdm.Document  ");

        dt = StockReports.GetDataTable(sb.ToString());
        chkDocuments.DataSource = dt;
        chkDocuments.DataTextField = "Document";
        chkDocuments.DataValueField = "DocumentID";
        chkDocuments.DataBind();
    }

    private void LoadDocumentDetail()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DocumentID ");
        sb.Append("FROM f_paneldocumentdetail ");
        sb.Append("Where IsActive=1  ");

        if(ddlPanel.SelectedItem.Value.ToUpper() =="SELECT")
        {
                lblMsg.Text = "Select Panel ...";
                return;
        }



        dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkDocuments.Items)
                {
                    if (dr["DocumentID"].ToString() == li.Value)
                    {
                        li.Selected = true;
                        li.Attributes.Add("Style", "color:Brown");
                    }
                }
            }
        }
    }

    private void LoadPanel()
    {
        DataTable dtPanel = LoadCacheQuery.loadAllPanel();
        foreach (DataRow dr in dtPanel.Rows)
        {
            ListItem li2 = new ListItem(dr[0].ToString(), dr[1].ToString());
            ddlPanel.Items.Add(li2);
        }

        ddlPanel.Items.Insert(0, new ListItem("SELECT", "SELECT"));
    }

    private void UpdatePanelForDocuments()
    {
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT pnl.Company_Name,pnl.PanelID FROM f_panel_master pnl ");
        sb.Append("LEFT JOIN (SELECT PanelID FROM f_paneldocumentdetail WHERE isactive=1 GROUP BY PanelID)pd ON ");
        sb.Append("pd.PanelID = pnl.PanelID WHERE pnl.IsActive=1 AND pd.PanelID IS NULL ");

        dt = StockReports.GetDataTable(sb.ToString());

        chkPanel2.DataSource = dt;
        chkPanel2.DataTextField = "Company_Name";
        chkPanel2.DataValueField = "PanelID";
        chkPanel2.DataBind();
    }
}