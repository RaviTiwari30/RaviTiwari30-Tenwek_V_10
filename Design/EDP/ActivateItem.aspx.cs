using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_ActivateItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadEmployee();            
        }
    }

    private void LoadEmployee()
    {
        string str = "Select EmployeeID,concat(Title,' ', Name)Name,if(IsActive=1,'True','False')IsActive from employee_master Where IsActive="+ rbtActive.SelectedValue +" order by Name";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chkItem.DataSource = dt;
        chkItem.DataTextField = "Name";
        chkItem.DataValueField = "EmployeeID";
        chkItem.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkItem.Items)
                {
                    if (dr["EmployeeID"].ToString() == li.Value)
                    {
                        li.Selected = Util.GetBoolean(dr["IsActive"]);
                        break;
                    }
                }
            }
        }
    }

    private void LoadDoctor()
    {
        string str = "Select DoctorID,concat(Title,' ', Name)Name,if(IsActive=1,'True','False')IsActive from Doctor_master Where IsActive=" + rbtActive.SelectedValue + " order by Name";

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);
        chkItem.DataSource = dt;
        chkItem.DataTextField = "Name";
        chkItem.DataValueField = "DoctorID";
        chkItem.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkItem.Items)
                {
                    if (dr["DoctorID"].ToString() == li.Value)
                    {
                        li.Selected = Util.GetBoolean(dr["IsActive"]);
                        break;
                    }
                }
            }
        }
    }

    protected void rdbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdbType.SelectedValue == "0")
        { 
            LoadEmployee();
        }
        else  if (rdbType.SelectedValue == "1")
        {
            LoadDoctor();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string sb = "";

        try
        {
            if (rdbType.SelectedValue == "0")
            {
                foreach (ListItem li in chkItem.Items)
                {
                    if (li.Selected)
                    {
                        sb = "Update Employee_master Set IsActive=1 where EmployeeID='" + li.Value + "';";                        
                        StockReports.ExecuteDML(sb);
                    }
                    else
                    {
                        sb="Update Employee_master Set IsActive=0 where EmployeeID='" + li.Value + "';";
                        StockReports.ExecuteDML(sb);
                    }
                }
            }
            else if (rdbType.SelectedValue == "1")
            {
                foreach (ListItem li in chkItem.Items)
                {
                    if (li.Selected)
                    {
                       
					   
					   

                        
                            sb = "UPDATE Doctor_master dm INNER JOIN f_itemmaster im ON dm.DoctorID=im.type_ID " +
                                 " INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=im.SubCategoryID " +
                                 " INNER JOIN f_categorymaster cat ON cat.CategoryID=sub.CategoryID INNER JOIN " +
                                 " f_configrelation con ON con.categoryID=cat.categoryID SET dm.isActive=1,im.isActive=1 " +
                                 " WHERE con.ConfigID IN (1,5) AND dm.DoctorID='" + li.Value + "' AND im.type_ID='" + li.Value + "' ";
                            StockReports.ExecuteDML(sb);
                        
					    
					   
					   
                        //sb = "UPDATE Doctor_master dm INNER JOIN f_itemmaster im ON dm.DoctorID=im.type_ID " +
                        //     " INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=im.SubCategoryID " +
                        //     " INNER JOIN f_categorymaster cat ON cat.CategoryID=sub.CategoryID INNER JOIN " +
                        //     " f_configrelation con ON con.categoryID=cat.categoryID SET dm.isActive=1,im.isActive=1 " +
                        //     " WHERE con.ConfigID IN (1,5) AND dm.DoctorID='" + li.Value + "' AND im.type_ID='" + li.Value + "' ";
                       // StockReports.ExecuteDML(sb);
                    }
                    else
                    {
                        sb = "UPDATE Doctor_master dm INNER JOIN f_itemmaster im ON dm.DoctorID=im.type_ID " +
                              " INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=im.SubCategoryID " +
                              " INNER JOIN f_categorymaster cat ON cat.CategoryID=sub.CategoryID INNER JOIN " +
                              " f_configrelation con ON con.categoryID=cat.categoryID SET dm.isActive=0,im.isActive=0 " +
                              " WHERE con.ConfigID IN (1,5) AND dm.DoctorID='" + li.Value + "' AND im.type_ID='" + li.Value + "' ";
                        StockReports.ExecuteDML(sb);
                    }
                }
                //drop cache
                LoadCacheQuery.dropCache("Doctor"+"_"+Session["CentreID"].ToString());
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM07','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void rbtActive_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdbType.SelectedValue == "0")
        {
            LoadEmployee();
        }
        else if (rdbType.SelectedValue == "1")
        {
            LoadDoctor();
        }
    }
}
