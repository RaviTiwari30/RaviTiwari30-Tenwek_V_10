using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using MySql.Data.MySqlClient;
public partial class Design_Token_ModalityMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod]
    public static string BindFloor()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(AllLoadData_IPD.loadFloor());
    }

    [WebMethod(EnableSession = true)]
    public static string SaveModality(string subcategoryid, string modalityName, string floor, string floorid, string roomno, string modalityID, string Active, string btnvalue,string centreID)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            ExcuteCMD excuteCMD = new ExcuteCMD();
            string message = string.Empty;
            string str = "Select count(id) from modality_master where NAME='" + modalityName + "' and SubCategoryID='" + subcategoryid + "' and centreID=" + centreID + ""; ;
            int isExists = Util.GetInt(StockReports.ExecuteScalar(str));
            if (isExists != 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Modality Name Already Exist !!!" });
            }


            if (btnvalue == "Save" && modalityID == "0")
            {
                string sqlCMD = "insert into modality_master (SubCategoryID,NAME,floor,RoomNo,CreateBy,CentreID) values(@SubCategoryID,@modalityName,@floor,@roomno,@CreatedBy,@CentreId)";

                excuteCMD.DML(tranX, sqlCMD, CommandType.Text, new
                {
                    SubCategoryID = subcategoryid,
                    modalityName = modalityName,
                    floor = floor,
                    roomno = roomno,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    CentreId = centreID
                });
                message = "Modality Saved Successfully";
            }
            else if (btnvalue == "Update" && modalityID != "0")
            {
                string sqlCMD = "UPDATE modality_master SET NAME = @modalityName,SubCategoryID = @SubCategoryID,IsActive = @Active,RoomNo = @roomno,FLOOR= @floor,centreID=@centreID WHERE ID = @modalityID ";

                excuteCMD.DML(tranX, sqlCMD, CommandType.Text, new
                {
                    SubCategoryID = subcategoryid,
                    modalityName = modalityName,
                    floor = floor,
                    roomno = roomno,
                    Active = Active,
                    modalityID = modalityID,
                    centreID = centreID
                });

                message = "Modality Update Successfully";
            }
            tranX.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, message = message });
        }
        catch (Exception ex)
        {

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tranX.Rollback();
            con.Close();
            con.Dispose();

            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, message = "Record not Saved" });
        }

    }


    [WebMethod]
    public static string SearchModality(string subcategoryId,string CentreID)
    {
        string str = " SELECT mm.ID,cm.CentreName,mm.NAME ModalityName,Sm.Name SubcategoryName,sm.SubCategoryID,RoomNo,FLOOR,IF(mm.Isactive=1,'Active','DeActive')ActiveStatus,IF(mm.isactive=1,'1','0')Isactive FROM modality_master mm INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=mm.SubCategoryID inner join Center_MAster cm on cm.CentreID= mm.CentreID where mm.CentreID=" + CentreID + " ";
        if (subcategoryId != "0")
            str = str + "and mm.SubCategoryID='" + subcategoryId + "'";
        DataTable dt = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}