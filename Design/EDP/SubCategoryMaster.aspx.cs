using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;
using Saplin.Controls;

public partial class Design_EDP_SubCategoryMaster : System.Web.UI.Page
{
    public void BindCategory()
    {
        try
        {
            string str = "select concat(cm.CategoryID,'#',ConfigID)CategoryID,cm.Name from f_categorymaster cm inner join f_configrelation c on cm.CategoryID =c.CategoryID where cm.active=1 AND c.ConfigID NOT IN (3,2) order by cm.name";
            DataTable dt = StockReports.GetDataTable(str);
            ddlCategoryName.DataSource = dt;
            ddlCategoryName.DataValueField = "CategoryID";
            ddlCategoryName.DataTextField = "Name";
            ddlCategoryName.DataBind();

            ddlCategory2.DataSource = dt;
            ddlCategory2.DataValueField = "CategoryID";
            ddlCategory2.DataTextField = "Name";
            ddlCategory2.DataBind();

            if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "1")
                chkScheduler.Visible = true;
            else
                chkScheduler.Visible = false;

            divIsAsset.Visible = false;
            rbisAsset.Visible = false;

            divdepart.Visible = false;
            ddlDept.Visible = false;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public void BindDisplayName()
    {
        DataTable dt1 = All_LoadData.LoadDisplayName();
        ddlDisplayName.DataSource = dt1;
        ddlDisplayName.DataValueField = "DisplayName";
        ddlDisplayName.DataTextField = "DisplayName";
        ddlDisplayName.DataBind();
        ViewState["DisplayName"] = dt1;
        ddlDisplayName.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BindDepartment()
    {
        DataView dv = LoadCacheQuery.bindStoreDepartment().DefaultView;
        //  dv.RowFilter = " LedgerNumber <> '" + ViewState["DeptLedgerNo"].ToString() + "' ";
        DataTable dt = dv.ToTable();
        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            lblMsg.Text = string.Empty;
            // ddlDept.Items.Insert(0, new ListItem("Select", "0"));

        }
        else
        {
            ddlDept.Items.Clear();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM254','" + lblMsg.ClientID + "');", true);
        }

    }

    public void BindGrid()
    {

        string sql = "select c.ConfigID,sm.SubCategoryID,sm.CategoryID,sm.Name,sm.Description,sm.DisplayName,sm.DisplayPriority, " +
            " sm.Active,sm.abbreviation,sm.DocValidityPeriod,sm.IsAsset,sm.Asset_DepartId,sm.ScaleOfCost from f_subcategorymaster sm " +
            " inner join f_configrelation c on c.CategoryID = sm.CategoryID " +
            " where sm.CategoryID='" + ddlCategory2.SelectedValue.Split('#')[0] + "' ";

        grdSubCategory.DataSource = StockReports.GetDataTable(sql);
        grdSubCategory.DataBind();
    }



    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtName.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblMsg.ClientID + "');", true);
            txtName.Focus();
            return;
        }
        if (ddlDisplayName.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select Display Name";
            ddlDisplayName.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Util.GetInt(ddlCategoryName.SelectedValue.Split('#')[1]) == 2)
            {
                ipd_case_type_master IPCM = new ipd_case_type_master(Tranx);
                IPCM.Name = txtName.Text;
                IPCM.Description = "";
                IPCM.Ownership = "Public";
                IPCM.Creator_Date = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                IPCM.No_Of_Round = Util.GetInt("0");
                IPCM.Creator_Id = ViewState["UID"].ToString();
                if (rbtnActive.SelectedItem.Value == "YES")
                {
                    IPCM.IsActive = 1;
                }
                else if (rbtnActive.SelectedItem.Value == "NO")
                {
                    IPCM.IsActive = 0;
                }
                IPCM.IpAddress = All_LoadData.IpAddress();

                string ipdCaseTypeID = IPCM.Insert();
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE ipd_case_type_master SET BillingCategoryID='" + ipdCaseTypeID + "' WHERE IPDCaseType_ID='" + ipdCaseTypeID + "'");

                SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0];
                objSubCategoryMaster.Name = txtName.Text.Trim();
                objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
                objSubCategoryMaster.DisplayPriority = Util.GetInt(txtPrintOrder.Text.Trim());
                objSubCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();
                objSubCategoryMaster.Description = Util.GetString(ipdCaseTypeID);
                if (rbtnActive.SelectedItem.Value == "YES")
                    objSubCategoryMaster.Active = 1;
                else if (rbtnActive.SelectedItem.Value == "NO")
                    objSubCategoryMaster.Active = 0;


                objSubCategoryMaster.IsAsset = 0;

                objSubCategoryMaster.IPAddress = All_LoadData.IpAddress();

                string SubCategoryID = objSubCategoryMaster.Insert();
                ItemMaster objIMaster = new ItemMaster(Tranx);
                objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objIMaster.Type_ID = Util.GetInt(ipdCaseTypeID);
                objIMaster.TypeName = txtName.Text.Trim();
                objIMaster.Description = "";
                objIMaster.SubCategoryID = SubCategoryID;
                objIMaster.IsEffectingInventory = "No";
                objIMaster.IsExpirable = "";
                objIMaster.BillingUnit = "";
                objIMaster.Pulse = "";
                objIMaster.IsTrigger = Util.GetString("YES");
                objIMaster.StartTime = Util.GetDateTime("00:00:00");
                objIMaster.EndTime = Util.GetDateTime("00:00:00");
                objIMaster.BufferTime = Util.GetString("0");
                objIMaster.IsActive = Util.GetInt("1");
                objIMaster.QtyInHand = Util.GetDecimal("0");
                objIMaster.IsAuthorised = Util.GetInt("1");
                objIMaster.UnitType = "";
                objIMaster.IPAddress = All_LoadData.IpAddress();
                objIMaster.CreaterID = Session["ID"].ToString();
                objIMaster.Insert().ToString();
            }
            else if (Util.GetInt(ddlCategoryName.SelectedValue.Split('#')[1]) == 1)
            {
                SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0];
                objSubCategoryMaster.Name = txtName.Text.Trim();
                objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
                objSubCategoryMaster.DisplayPriority = Util.GetInt(txtPrintOrder.Text.Trim());
                objSubCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();
                objSubCategoryMaster.Description = "OPD";
                objSubCategoryMaster.scaleOfCost = Util.GetDecimal(txtScaleOfCost.Text);

                if (objSubCategoryMaster.scaleOfCost <= 0)
                {
                    objSubCategoryMaster.scaleOfCost = 1;

                }



                if (rbtnActive.SelectedItem.Value == "YES")
                {
                    objSubCategoryMaster.Active = 1;
                }
                else if (rbtnActive.SelectedItem.Value == "NO")
                {
                    objSubCategoryMaster.Active = 0;
                }

                objSubCategoryMaster.IsAsset = 0;

                objSubCategoryMaster.IPAddress = All_LoadData.IpAddress();
                string SubCategoryID = objSubCategoryMaster.Insert();

                DataTable dt = StockReports.GetDataTable("select DoctorID,Name from doctor_master ");
                ItemMaster objIMaster;

                foreach (DataRow dr in dt.Rows)
                {
                    objIMaster = new ItemMaster(Tranx);
                    objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objIMaster.Type_ID = Util.GetInt(dr["DoctorID"].ToString());
                    objIMaster.TypeName = dr["Name"].ToString();
                    objIMaster.Description = "IPD";
                    objIMaster.SubCategoryID = SubCategoryID;
                    objIMaster.IsEffectingInventory = "No";
                    objIMaster.IsExpirable = "";
                    objIMaster.BillingUnit = "";
                    objIMaster.Pulse = "";
                    objIMaster.IsTrigger = Util.GetString("YES");
                    objIMaster.StartTime = Util.GetDateTime("00:00:00");
                    objIMaster.EndTime = Util.GetDateTime("00:00:00");
                    objIMaster.BufferTime = Util.GetString("0");
                    objIMaster.IsActive = Util.GetInt("1");
                    objIMaster.QtyInHand = Util.GetDecimal("0");
                    objIMaster.IsAuthorised = Util.GetInt("1");
                    objIMaster.UnitType = "";
                    objIMaster.IPAddress = All_LoadData.IpAddress();
                    objIMaster.CreaterID = Session["ID"].ToString();
                    objIMaster.Insert().ToString();

                    string strSchd = "Insert into f_scheduledconsultant(SubCategoryID,DoctorID)";
                    strSchd += "values('" + SubCategoryID + "','" + dr["DoctorID"].ToString() + "')";

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strSchd);
                }
            }
            else if (Util.GetInt(ddlCategoryName.SelectedValue.Split('#')[1]) == 5)
            {
                SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0];
                objSubCategoryMaster.Name = txtName.Text.Trim();
                objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
                objSubCategoryMaster.DisplayPriority = Util.GetInt(txtPrintOrder.Text.Trim());
                objSubCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();
                objSubCategoryMaster.Description = "OPD";
                if (rbtnActive.SelectedItem.Value == "YES")
                    objSubCategoryMaster.Active = 1;
                else if (rbtnActive.SelectedItem.Value == "NO")
                    objSubCategoryMaster.Active = 0;

                objSubCategoryMaster.IsAsset = 0;

                objSubCategoryMaster.IPAddress = All_LoadData.IpAddress();
                objSubCategoryMaster.DocValidityPeriod = Util.GetInt(txtValidityPeriod.Text.Trim());
                string SubCategoryID = objSubCategoryMaster.Insert();

                DataTable dt = StockReports.GetDataTable("select DoctorID,Name from doctor_master ");
                ItemMaster objIMaster;

                foreach (DataRow dr in dt.Rows)
                {
                    objIMaster = new ItemMaster(Tranx);
                    objIMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                    objIMaster.Type_ID = Util.GetInt(dr["DoctorID"].ToString());
                    objIMaster.TypeName = dr["Name"].ToString();
                    objIMaster.Description = "OPD";
                    objIMaster.SubCategoryID = SubCategoryID;
                    objIMaster.IsEffectingInventory = "No";
                    objIMaster.IsExpirable = "";
                    objIMaster.BillingUnit = "";
                    objIMaster.Pulse = "";
                    objIMaster.IsTrigger = Util.GetString("YES");
                    objIMaster.StartTime = Util.GetDateTime("00:00:00");
                    objIMaster.EndTime = Util.GetDateTime("00:00:00");
                    objIMaster.BufferTime = Util.GetString("0");
                    objIMaster.IsActive = Util.GetInt("1");
                    objIMaster.QtyInHand = Util.GetDecimal("0");
                    objIMaster.IsAuthorised = Util.GetInt("1");
                    objIMaster.UnitType = "";
                    objIMaster.IPAddress = All_LoadData.IpAddress();
                    objIMaster.CreaterID = Session["ID"].ToString();
                    objIMaster.ValidityPeriod = Util.GetInt(txtValidityPeriod.Text.Trim());
                    objIMaster.Insert().ToString();
                }
            }
            else if (Util.GetInt(ddlCategoryName.SelectedValue.Split('#')[1]) == 3)
            {
                SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0];
                objSubCategoryMaster.Name = txtName.Text.Trim();
                objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
                objSubCategoryMaster.DisplayPriority = Util.GetInt(txtPrintOrder.Text.Trim());
                objSubCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();

                if (rbtnActive.SelectedItem.Value == "YES")
                {
                    objSubCategoryMaster.Active = 1;
                }
                else if (rbtnActive.SelectedItem.Value == "NO")
                {
                    objSubCategoryMaster.Active = 0;
                }
                objSubCategoryMaster.IsAsset = 0;
                objSubCategoryMaster.IPAddress = All_LoadData.IpAddress();
                string SubCategoryID = objSubCategoryMaster.Insert();

                ObservationType_Master objObservationType_Master = new ObservationType_Master(Tranx);
                objObservationType_Master.Name = txtName.Text.Trim();
                objObservationType_Master.Ownership = "Public";
                objObservationType_Master.Flag = 1;
                objObservationType_Master.Description = SubCategoryID;
                objObservationType_Master.Creator_ID = ViewState["UID"].ToString();
                objObservationType_Master.Insert();
            }
            else if (Util.GetInt(ddlCategoryName.SelectedValue.Split('#')[1]) == 28)
            {
                SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0];
                objSubCategoryMaster.Name = txtName.Text.Trim();
                objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
                objSubCategoryMaster.DisplayPriority = Util.GetInt(txtPrintOrder.Text.Trim());
                objSubCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();

                if (rbtnActive.SelectedItem.Value == "YES")
                {
                    objSubCategoryMaster.Active = 1;
                }
                else if (rbtnActive.SelectedItem.Value == "NO")
                {
                    objSubCategoryMaster.Active = 0;
                }

                if (rbisAsset.SelectedItem.Value == "YES")
                {
                    objSubCategoryMaster.IsAsset = 1;
                }
                else if (rbisAsset.SelectedItem.Value == "NO")
                {
                    objSubCategoryMaster.IsAsset = 0;
                }
                objSubCategoryMaster.IPAddress = All_LoadData.IpAddress();
                string SubCategoryID = objSubCategoryMaster.Insert();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "SaveDepartId();", true);
            }
            else
            {
                SubCategoryMaster objSubCategoryMaster = new SubCategoryMaster(Tranx);
                objSubCategoryMaster.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objSubCategoryMaster.CategoryID = ddlCategoryName.SelectedValue.Split('#')[0];
                objSubCategoryMaster.Name = txtName.Text.Trim();
                objSubCategoryMaster.DisplayName = ddlDisplayName.SelectedValue;
                objSubCategoryMaster.DisplayPriority = Util.GetInt(txtPrintOrder.Text.Trim());
                objSubCategoryMaster.Abbreviation = txtAbbreviation.Text.Trim();

                if (rbtnActive.SelectedItem.Value == "YES")
                {
                    objSubCategoryMaster.Active = 1;
                }
                else if (rbtnActive.SelectedItem.Value == "NO")
                {
                    objSubCategoryMaster.Active = 0;
                }
                objSubCategoryMaster.IPAddress = All_LoadData.IpAddress();
                string SubCategoryID = objSubCategoryMaster.Insert();
            }

            Tranx.Commit();
            clear();
            LoadCacheQuery.dropCache("SubCategory");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnSearch_Click1(object sender, EventArgs e)
    {
        BindGrid();
    }

    protected void ddlCategoryName_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "1")
            {
                chkScheduler.Visible = true;
                divScaleOfCost.Attributes.CssStyle.Add("display", "");
            }
            else if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "22")
            {
                chkScheduler.Visible = false;
                divScaleOfCost.Attributes.CssStyle.Add("display", "");
            }
            else
            {
                chkScheduler.Visible = false;
                divScaleOfCost.Attributes.CssStyle.Add("display", "None");
            }

            if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "5")
            {
                trValidityPeriod.Visible = true;
            }
            else
            {
                trValidityPeriod.Visible = false;
                txtValidityPeriod.Text = "";
            }

            if (ddlCategoryName.SelectedItem.Value.Split('#')[1].ToString() == "28")
            {
                divIsAsset.Visible = true;
                rbisAsset.Visible = true;
                divdepart.Visible = true;
                ddlDept.Visible = true;
            }
            else
            {
                divIsAsset.Visible = false;
                rbisAsset.Visible = false;
                divdepart.Visible = false;
                ddlDept.Visible = false;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdSubCategory_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;

        var configID=Util.GetInt(ddlCategory2.SelectedValue.Split('#')[1]);

        if (configID != 1 && configID != 22)
        {
            e.Row.Cells[8].Visible = false;
        }


        if (Util.GetInt(ddlCategory2.SelectedValue.Split('#')[1]) != 28)
        {
            e.Row.Cells[7].Visible = false;
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            row = (DataRowView)e.Row.DataItem;
            e.Row.Attributes.Add("onMouseOver", "SetNewColor(this);");
            e.Row.Attributes.Add("onMouseOut", "SetOldColor(this);");

            DataTable dt = (DataTable)ViewState["DisplayName"];
            ((DropDownList)e.Row.FindControl("ddlDisplayName2")).DataSource = dt;
            ((DropDownList)e.Row.FindControl("ddlDisplayName2")).DataTextField = "DisplayName";
            ((DropDownList)e.Row.FindControl("ddlDisplayName2")).DataValueField = "DisplayName";
            ((DropDownList)e.Row.FindControl("ddlDisplayName2")).DataBind();

            ((DropDownList)e.Row.FindControl("ddlDisplayName2")).SelectedIndex =
             ((DropDownList)e.Row.FindControl("ddlDisplayName2")).Items.IndexOf(
                ((DropDownList)e.Row.FindControl("ddlDisplayName2")).Items.FindByValue(((Label)e.Row.FindControl("lblDisplayName")).Text));

            if (((Label)e.Row.FindControl("lblActive")).Text == "1")
                ((RadioButtonList)e.Row.FindControl("rbtnActive2")).SelectedIndex = 0;
            else
                ((RadioButtonList)e.Row.FindControl("rbtnActive2")).SelectedIndex = 1;

            if (((Label)e.Row.FindControl("lblIsAsset")).Text == "True")
            {
                ((RadioButtonList)e.Row.FindControl("rbtnIsAsset")).SelectedIndex = 0;
            }
            else
            {
                ((RadioButtonList)e.Row.FindControl("rbtnIsAsset")).SelectedIndex = 1;
            }

            if (((Label)e.Row.FindControl("lblConfigID")).Text == "5")
            {
                ((TextBox)e.Row.FindControl("txtValidityPeriod")).Enabled = true;
            }
            else
            {
                ((TextBox)e.Row.FindControl("txtValidityPeriod")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtValidityPeriod")).Text = "";
            }

            if (((Label)e.Row.FindControl("lblIsAsset")).Text == "True")
            {
                string id = ((Label)e.Row.FindControl("lblDepartment")).Text;
                if (id != "0")
                {
                    DropDownCheckBoxes ddl = ((DropDownCheckBoxes)e.Row.FindControl("ddlDepartment"));
                    DataView dv = LoadCacheQuery.bindStoreDepartment().DefaultView;
                    DataTable dtt = dv.ToTable();
                    if (dtt.Rows.Count > 0)
                    {
                        ddl.DataSource = dtt;
                        ddl.DataTextField = "ledgerName";
                        ddl.DataValueField = "LedgerNumber";
                        ddl.DataBind();
                        //lblMsg.Text = string.Empty;
                    }
                    else { ddl.Items.Clear(); }
                    string[] strarray = id.Split(',');

                    for (int i = 0; i < strarray.Length; i++)
                    {
                        for (int k = 0; k < ddl.Items.Count; k++)
                        {
                            if (strarray[i] == ddl.Items[k].Value)
                            {
                                ddl.Items[k].Selected = true;
                            }
                        }
                    }
                }
            }
            else
            {
                DropDownCheckBoxes ddl = ((DropDownCheckBoxes)e.Row.FindControl("ddlDepartment"));
                ddl.Visible = false;
            }
        }
    }

    protected void grdSubCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        string name = "";
        DropDownCheckBoxes ddl = ((DropDownCheckBoxes)grdSubCategory.SelectedRow.FindControl("ddlDepartment"));
        for (int i = 0; i < ddl.Items.Count; i++)
        {
            if (ddl.Items[i].Selected)
            {
                name += ddl.Items[i].Value + ",";
            }
        }
        name = name.TrimEnd(',');

        //if (name != "")
        //{
        string ConfigID = "", SubCategoryID = "", CategoryID = "",
            Name = "", Description = "", displayName = "", DisplayPriority = "", Active = "",
            abbreviation = "";
        int isAsset = 0;
        int ValidityPeriod = 0;


        ConfigID = ((Label)grdSubCategory.SelectedRow.FindControl("lblConfigID")).Text;
        SubCategoryID = ((Label)grdSubCategory.SelectedRow.FindControl("lblSubCategoryID")).Text;
        CategoryID = ((Label)grdSubCategory.SelectedRow.FindControl("lblCategoryID")).Text;
        Description = ((Label)grdSubCategory.SelectedRow.FindControl("lblDescription")).Text;

        Name = ((TextBox)grdSubCategory.SelectedRow.FindControl("txtName")).Text.Trim();
        abbreviation = ((TextBox)grdSubCategory.SelectedRow.FindControl("txtabbreviation")).Text.Trim();
        DisplayPriority = ((TextBox)grdSubCategory.SelectedRow.FindControl("txtDisplayPriority")).Text.Trim();
       decimal scaleOfCost = Util.GetDecimal(((TextBox)grdSubCategory.SelectedRow.FindControl("txtScaleOfCost")).Text.Trim());


       if (scaleOfCost <= 0)
           scaleOfCost = 1;


        if (((RadioButtonList)grdSubCategory.SelectedRow.FindControl("rbtnActive2")).SelectedItem.Value == "YES")
            Active = "1";
        else
            Active = "0";

        if (((RadioButtonList)grdSubCategory.SelectedRow.FindControl("rbtnIsAsset")).SelectedItem.Value == "YES")
        {
            isAsset = 1;
        }
        else { isAsset = 0; name = ""; }

        displayName = ((Label)grdSubCategory.SelectedRow.FindControl("lblDisplayName")).Text;
        string disName = ((DropDownList)grdSubCategory.SelectedRow.FindControl("ddlDisplayName2")).Text;

        ValidityPeriod = Util.GetInt(((TextBox)grdSubCategory.SelectedRow.FindControl("txtValidityPeriod")).Text.Trim());

        if (Name.Trim() == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM049','" + lblMsg.ClientID + "');", true);
            ((TextBox)grdSubCategory.SelectedRow.FindControl("txtName")).Focus();
            return;
        }

        if (disName.Trim() == "Select")
        {
            lblMsg.Text = "Please Select Display Name";
            ((DropDownList)grdSubCategory.SelectedRow.FindControl("ddlDisplayName2")).Focus();
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            string sql = " update f_subcategorymaster set Name='" + Name + "', DisplayName='" + disName +
                "', DisplayPriority='" + DisplayPriority + "', Active='" + Active + "', abbreviation='" + abbreviation + "',DocValidityPeriod='" + ValidityPeriod + "', IsAsset='" + isAsset + "', Asset_DepartId='" + name + "',scaleOfCost=" + scaleOfCost + " where SubCategoryID='" + SubCategoryID + "' ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            if (Util.GetInt(ConfigID) == 5)
            {
                sql = " update f_itemmaster set ValidityPeriod='" + ValidityPeriod + "' WHERE SubCategoryID='" + SubCategoryID + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else if (Util.GetInt(ConfigID) == 2)
            {
                sql = " update ipd_case_type_master set Name='" + Name + "' , IsActive='" + Active + "' WHERE IPDCaseType_ID='" + Description + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);

                sql = " update f_itemmaster set TypeName='" + Name + "' where SubCategoryID='" + SubCategoryID + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            else if (Util.GetInt(ConfigID) == 3)
            {
                sql = " update observationtype_master set Name='" + Name + "' where Description='" + SubCategoryID + "' ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            LoadCacheQuery.dropCache("SubCategory");
            tnx.Commit();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

            BindGrid();
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
        //}
        //else 
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "script", "GetError();", true);
        //}
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MultiView1.ActiveViewIndex = 0;
            ViewState["UID"] = Session["ID"].ToString();
            BindCategory();
            BindDisplayName();
            BindDepartment();
        }
    }

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnStatus.SelectedItem.Text == "NEW")
        {
            MultiView1.ActiveViewIndex = 0;
        }
        else
        {
            MultiView1.ActiveViewIndex = 1;
        }
    }

    private void clear()
    {
        txtName.Text = "";
        txtAbbreviation.Text = "";
        ddlDisplayName.SelectedIndex = 0;
        txtPrintOrder.Text = "";
        txtValidityPeriod.Text = "";
    }

    public static int GetmaxID()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = 0;

        string query = "SELECT MAX(ID) FROM f_Subcategorymaster";
        using (MySqlCommand cmd = new MySqlCommand(query, con))
        {
            cmd.CommandType = CommandType.Text;
            max = Convert.ToInt32(cmd.ExecuteScalar());
            con.Close();
        }
        return max;
    }

    [WebMethod(EnableSession = true)] // developed by Ankit
    public static string SaveDepartment(string DepartID)
    {
        string Result = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        int max = 0;
        max = GetmaxID();

        using (MySqlTransaction tr = con.BeginTransaction())
        {
            try
            {
                string query = "UPDATE f_Subcategorymaster SET Asset_DepartId='" + DepartID + "' WHERE ID='" + max + "'";
                using (MySqlCommand cmd = new MySqlCommand(query, con, tr))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.ExecuteNonQuery();
                    tr.Commit();
                    con.Close();
                    Result = "1";
                }
            }
            catch
            {
                tr.Rollback();
                Result = "0";
            }
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(Result);
    }

    protected void rbtnIsAsset_SelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (GridViewRow r in grdSubCategory.Rows)
        {
            if (r.RowType == DataControlRowType.DataRow)
            {
                RadioButtonList rd = (r.Cells[7].FindControl("rbtnIsAsset") as RadioButtonList);
                string aset = rd.SelectedItem.Text;

                if (aset == "YES")
                {
                    DropDownCheckBoxes d = (r.Cells[8].FindControl("ddlDepartment") as DropDownCheckBoxes);
                    d.Visible = true;
                    DataView dv = LoadCacheQuery.bindStoreDepartment().DefaultView;
                    DataTable dtt = dv.ToTable();
                    if (dtt.Rows.Count > 0)
                    {
                        d.DataSource = dtt;
                        d.DataTextField = "ledgerName";
                        d.DataValueField = "LedgerNumber";
                        d.DataBind();
                        //lblMsg.Text = string.Empty;
                    }
                    else { d.Items.Clear(); }
                }
            }

        }
    }

}