using System;
using System.Data;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;


public partial class Design_LAB_FormulaMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadHead();
            BindInvestigations();
            LoadObservations();
        }
       txtFormulaRight.Attributes.Add("readOnly", "true");
    }
    private void LoadObservations()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lom.labobservation_id,lom.name,lom.formula FROM labobservation_investigation loi INNER JOIN labobservation_master lom ");
        sb.Append("ON loi.labobservation_id=lom.labobservation_id WHERE loi.investigation_id='" + ddlInvestigations.SelectedValue + "' and loi.Child_Flag=0");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lstObservations.DataSource = dt;
            lstObservations.DataTextField = "Name";
            lstObservations.DataValueField = "labobservation_id";
            lstObservations.DataBind();
        }
        else
        {
            lstObservations.Items.Clear();
        }
    }
    private void LoadHead()
    {
        DataTable dtdept = AllLoadData_OPD.BindLabRadioDepartment(Session["RoleID"].ToString());
        ddlHead.DataSource = dtdept;
        ddlHead.DataTextField = "Name";
        ddlHead.DataValueField = "ObservationType_ID";
        ddlHead.DataBind();
        ddlHead.Items.Insert(0, new ListItem("All", "0"));
    }
    private void BindInvestigations()
    {
        string str = "SELECT im.Name,im.Investigation_Id FROM investigation_observationtype iot INNER JOIN investigation_master im ON iot.Investigation_ID=im.Investigation_Id inner join f_itemmaster i_m on im.Investigation_id=i_m.Type_id " ;
        str+= " inner join f_subcategorymaster sc on sc.SubCategoryID=i_m.SubCategoryID  " ;
         str+= " inner join f_configrelation c on c.CategoryID=sc.CategoryID ";
         str += " where c.configID='3' and c.CategoryID='3' ";
         if (ddlHead.SelectedItem.Value != "0")
             str += " and iot.ObservationType_ID='" + ddlHead.SelectedValue + "' ";
         str += " and i_m.IsActive=1  order by im.Name";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigations.DataSource = dt;
            ddlInvestigations.DataTextField = "Name";
            ddlInvestigations.DataValueField = "Investigation_Id";
            ddlInvestigations.DataBind();
        }
        else
        {
            ddlInvestigations.Items.Clear();
            ddlInvestigations.Items.Insert(0, new ListItem("No Test Found"));
        }
    }
    protected void ddlInvestigations_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadObservations();
    }
    protected void ddlHead_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindInvestigations();
        LoadObservations();
    }
    protected void btnLeft_Click(object sender, EventArgs e)
    {
        if (lstObservations.SelectedIndex != -1)
        {
            lblMsg.Text = "";
            string str = "SELECT formula,formulaText,LabObservation_ID,NAME FROM labobservation_master where labobservation_id='" + lstObservations.SelectedItem.Value + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows[0]["formulaText"].ToString() != "")
            {
                txtFormulaRightHidden.Text = dt.Rows[0]["formula"].ToString();
                txtFormulaRight.Text = dt.Rows[0]["formulaText"].ToString();
                txtFormulatxtHidden.Text = dt.Rows[0]["formulaText"].ToString();
                txtFormulaLeftHidden.Text = dt.Rows[0]["LabObservation_ID"].ToString();
                txtFormulaLeft.Text = dt.Rows[0]["NAME"].ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Formula Already Exists');", true);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Formula Already Exists...');", true);
            }
            else
            {
                txtFormulaLeft.Text = "";
                txtFormulaLeftHidden.Text = "";
                txtFormulaLeftHidden.Text = lstObservations.SelectedItem.Value;
                txtFormulaLeft.Text = lstObservations.SelectedItem.Text;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Observations');", true);
           // lblMsg.Text = "Please Select Observations";
            return;
        }
    }
    protected void BtnRight_Click(object sender, EventArgs e)
    {
        if (lstObservations.SelectedIndex != -1)
        {
            lblMsg.Text = "";

            txtFormulatxtHidden.Text = txtFormulatxtHidden.Text + lstObservations.SelectedItem.Text + "@";
            txtFormulatxt.Text = txtFormulatxtHidden.Text;
            txtFormulaRightHidden.Text = txtFormulaRightHidden.Text + lstObservations.SelectedItem.Value + "@";
            txtFormulaRight.Text = txtFormulatxtHidden.Text;
        }
        else
        {
            //lblMsg.Text = "Please Select Observations";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Select Observations');", true);
            return;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtFormulaRight.Text != "")
        {
            lblMsg.Text = "";
            StockReports.ExecuteDML("UPDATE labobservation_master SET formula='" + txtFormulaRightHidden.Text.ToString() + "',formulaText='" + txtFormulaRight.Text.ToString() + "' WHERE LabObservation_ID='" + txtFormulaLeftHidden.Text.ToString() + "'");
            clear();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Saved Successfully');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Please Create Formula');", true);
            //lblMsg.Text = "Please Create Formula";
            return;
        }
    }
    private void clear()
    {
        txtFormulaRight.Text = "";
        txtFormulaRightHidden.Text = "";
        txtFormulaRight.Text = "";
        txtFormulaRightHidden.Text = "";
        txtFormulatxt.Text = "";
        txtFormulaLeft.Text = "";
        txtFormulatxtHidden.Text = "";
    }
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        StockReports.ExecuteDML("UPDATE labobservation_master SET formula='',formulaText='' WHERE LabObservation_ID='" + txtFormulaLeftHidden.Text.ToString() + "'");
        clear();
       // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Record Removed Successfully');", true);
    }
    protected void btnClear_Click(object sender, EventArgs e)
    {
        clear();
    }
}




