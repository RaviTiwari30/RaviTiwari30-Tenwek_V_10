<%@ WebService Language="C#" Class="PanelMaster" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;
using System.Collections.Generic;
using System.Linq;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class PanelMaster : System.Web.Services.WebService
{

	[WebMethod]
	public string HelloWorld()
	{
		return "Hello World";
	}

	[WebMethod]
	public string GetCategoryMaster()
	{
		return Newtonsoft.Json.JsonConvert.SerializeObject(All_LoadData.LoadAllCategory());
	}

	[WebMethod]
	public string GetItems(string categoryID, string subCategoryID, string panelID, int operationType)
	{	
		var sqlCmd = new StringBuilder("SELECT im.ItemID,im.TypeName ItemName,sc.CategoryID, im.SubCategoryID," + operationType + " operationType,(SELECT SUM(Percentage)+SUM(PercentageIPD) FROM f_paneldisc  WHERE ItemID=im.ItemID and OperationType= " + operationType + " AND PanelID=" + panelID + ")PercentageSum ");
		//if (operationType == 1)
			//sqlCmd.Append(",(SELECT IsPayable FROM f_paneldisc  WHERE ItemID=im.ItemID and OperationType= " + operationType + " AND PanelID=" + panelID + ")IsPayable");
		sqlCmd.Append(",ifnull((SELECT IsPayable FROM f_paneldisc  WHERE ItemID=im.ItemID AND ispayable=1  and  PanelID=" + panelID + "),0)IsPayable,");
		
		//else
		//    sqlCmd.Append(",0 IsPayable");

		if (operationType == 3)
			sqlCmd.Append("(SELECT Percentage FROM  f_paneldisc f  WHERE f.ItemID= im.ItemID AND f.OperationType=3 AND f.PanelID=" + panelID + " ) OPDPercent,(SELECT PercentageIPD FROM  f_paneldisc f  WHERE f.ItemID= im.ItemID AND f.OperationType=3 AND f.PanelID=" + panelID + " ) IPDPercent ");
		else
			sqlCmd.Append("'' `OPDPercent`,'' IPDPercent");
		

		DataTable dt = StockReports.GetDataTable("SELECT pt.id,pt.PatientType FROM patient_type pt WHERE pt.IsActive=1");
		foreach (DataRow item in dt.Rows)
		{
			sqlCmd.Append(" ,IFNULL((SELECT CONCAT(IFNULL( pd.Percentage,0),'#',IFNULL( pd.PercentageIPD,0)) cash FROM f_paneldisc pd WHERE pd.ItemID = im.ItemID   AND OperationType= " + operationType + " and   pd.PatientTypeID = " + item["id"].ToString() + " AND pd.PanelID = " + panelID + "),'#') `" + item["PatientType"].ToString() + "_PatientType_" + item["id"].ToString() + "`");
		}

		sqlCmd.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID  WHERE im.IsActive = 1 AND sc.CategoryID = '" + categoryID + "' AND im.SubCategoryID = '" + subCategoryID + "' ");

		//  return sqlCmd.ToString();
		DataTable items=StockReports.GetDataTable(sqlCmd.ToString());
		
	   sqlCmd= new StringBuilder("SELECT SUM(OPDCategory)OPDCategory,SUM(IPDCategory)IPDCategory,SUM(OPDSubCategory)OPDSubCategory,SUM(IPDSubCategory)IPDSubCategory FROM( ");
				sqlCmd.Append(" SELECT IFNULL(f.Percentage,0) OPDCategory,IFNULL(f.PercentageIPD,0) IPDCategory,0 OPDSubCategory,0 IPDSubCategory  ");
				sqlCmd.Append("  FROM  f_paneldisc f WHERE f.PanelID=" + panelID + " AND f.OperationOn=1 AND f.OperationType=" + operationType + " AND f.CategoryID='" + categoryID + "' AND IFNULL(f.SubCategoryID,'')='' AND IFNULL(f.ItemID,'')=''  ");
				sqlCmd.Append("  UNION ALL ");
				sqlCmd.Append("  SELECT 0 OPDCategory,0 IPDCategory,IFNULL(f.Percentage,0) OPDSubCategory,IFNULL(f.PercentageIPD,0) IPDSubCategory FROM  f_paneldisc f WHERE f.PanelID=" + panelID + " AND f.OperationOn=2 AND f.OperationType=" + operationType + "  AND f.CategoryID='" + categoryID + "' AND f.SubCategoryID='" + subCategoryID + "' AND IFNULL(f.ItemID,'')='' ");
		  sqlCmd.Append("  )t ");



		DataTable _dt = StockReports.GetDataTable(sqlCmd.ToString());
		return JsonConvert.SerializeObject(new{items=items,data=_dt});
	}
	public class PercentOnCategory
	{
		public double OPDPercent { get; set; }
		public double IPDPercent { get; set; }
	}

	public class PercentOnSubCategory : PercentOnCategory { }



	[WebMethod(EnableSession = true)]
	public string SavePanelDiscount(int panelID, string categoryID, string subCategoryID, int operationType, List<FPaneldisc> data, PercentOnCategory percentOnCategory, PercentOnSubCategory percentOnSubCategory)
	{
		MySqlConnection con = Util.GetMySqlCon();
		con.Open();
		MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
		try
		{
			ExcuteCMD excuteCMD = new ExcuteCMD();
			var isPayable = operationType == 1 ? operationType : 0;


			if (operationType != 1)
			{

				if (!string.IsNullOrEmpty(categoryID))
				{
					excuteCMD.DML(tnx, "DELETE FROM f_paneldisc WHERE OperationOn = 1 and PanelID=@PanelID and operationType=@operationType and CategoryID=@categogyID", CommandType.Text, new
					{
						categogyID = Util.GetString(categoryID),
						operationType = operationType,
						PanelID = panelID
					});

					excuteCMD.DML(tnx, "Insert_fPanelDicount", CommandType.StoredProcedure, new
					{
						panelID = panelID,
						categoryID = categoryID,
						subCategoryID = "",
						itemID = "",
						percentage = percentOnCategory.OPDPercent,
						createdBy = HttpContext.Current.Session["ID"].ToString(),
						percentageIPD = percentOnCategory.IPDPercent,
						isPayable = 0,
						patientTypeID = 0,
						OperationType = operationType,
						OperationOn = 1
					});
				}

				if (!string.IsNullOrEmpty(subCategoryID))
				{
					excuteCMD.DML(tnx, "DELETE FROM f_paneldisc WHERE OperationOn = 2 and PanelID=@PanelID and operationType=@operationType and SubCategoryID=@SubCategoryID", CommandType.Text, new
					{
						SubCategoryID = Util.GetString(subCategoryID),
						operationType = operationType,
						PanelID = panelID
					});
					excuteCMD.DML(tnx, "Insert_fPanelDicount", CommandType.StoredProcedure, new
					{
						panelID = panelID,
						categoryID = categoryID,
						subCategoryID = subCategoryID,
						itemID = "",
						percentage = percentOnSubCategory.OPDPercent,
						createdBy = HttpContext.Current.Session["ID"].ToString(),
						percentageIPD = percentOnSubCategory.IPDPercent,
						isPayable = 0,
						patientTypeID = 0,
						OperationType = operationType,
						OperationOn = 2
					});
				}

			}


            if (operationType == 1 || operationType == 3)
            {
                excuteCMD.DML(tnx, con, "DELETE FROM  f_paneldisc  WHERE PanelID=@PanelID and OperationOn = 3 and (OperationType =3  or OperationType=1)  and SubCategoryID=@SubCategoryID", CommandType.Text, new { SubCategoryID = Util.GetString(subCategoryID), PanelID = panelID });
                
            }
            else
                excuteCMD.DML(tnx, con, "DELETE FROM  f_paneldisc  WHERE PanelID=@PanelID and OperationOn = 3 and OperationType=2 and    SubCategoryID=@SubCategoryID", CommandType.Text, new { SubCategoryID = Util.GetString(subCategoryID), PanelID = panelID });

            
			data.ForEach(i =>
			{

				var response = excuteCMD.DML(tnx, con, "Insert_fPanelDicount", CommandType.StoredProcedure, new
				{
					panelID = panelID,
					categoryID = categoryID,
					subCategoryID = subCategoryID,
					itemID = i.itemId,
					percentage = (isPayable == 1 ? 0 : i.percentage),
					createdBy = HttpContext.Current.Session["ID"].ToString(),
					percentageIPD = (isPayable == 1 ? 0 : i.IPDPercentage),
					isPayable = isPayable,
					patientTypeID = i.patientTypeID,
					OperationType = i.operationType,
					OperationOn = 3
				});
			});

			tnx.Commit();
			return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
		}
		catch (Exception ex)
		{
			tnx.Rollback();
			return JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
		}
		finally
		{
			con.Close();
			con.Dispose();
		}
	}




	[WebMethod(EnableSession = true)]
	public string copyPanelDiscount(int copyType, int copyFromPanel, string subCategoryID, int copyToPanel)
	{
		MySqlConnection con = Util.GetMySqlCon();
		con.Open();
		MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
		try
		{
			ExcuteCMD excuteCMD = new ExcuteCMD();
			if (copyType == 1)
			{
				excuteCMD.DML(tnx, con, "DELETE FROM  f_paneldisc  WHERE PanelID=@panelID AND SubCategoryID=@subCategory", CommandType.Text, new
				{
					panelID = copyToPanel,
					subCategory = subCategoryID
				});

				var sqlcmd = "INSERT INTO f_paneldisc(PanelID, CategoryID, SubCategoryID, ItemID, Percentage, CreatedBy, PercentageIPD, IsPayable, PatientTypeID,OperationType,OperationOn) SELECT @copyToPanel, CategoryID, SubCategoryID, ItemID, Percentage, @createdBy, PercentageIPD, IsPayable, PatientTypeID,OperationType,OperationOn FROM f_paneldisc WHERE PanelID=@panelID AND SubCategoryID=@subCategory";
				excuteCMD.DML(tnx, con, sqlcmd.ToString(), CommandType.Text, new
				{
					panelID = copyFromPanel,
					copyToPanel = copyToPanel,
					subCategory = subCategoryID,
					createdBy = HttpContext.Current.Session["ID"].ToString()
				});

			}
			else
			{
				excuteCMD.DML(tnx, con, "DELETE FROM  f_paneldisc  WHERE PanelID=@panelID ", CommandType.Text, new
				{
					panelID = copyToPanel,
				});

				var sqlcmd = "INSERT INTO f_paneldisc(PanelID, CategoryID, SubCategoryID, ItemID, Percentage, CreatedBy, PercentageIPD, IsPayable, PatientTypeID,OperationType,OperationOn) SELECT @copyToPanel, CategoryID, SubCategoryID, ItemID, Percentage, @createdBy, PercentageIPD, IsPayable, PatientTypeID,OperationType,OperationOn FROM f_paneldisc WHERE PanelID=@panelID";
				excuteCMD.DML(tnx, con, sqlcmd.ToString(), CommandType.Text, new
				{
					copyToPanel = copyToPanel,
					panelID = copyFromPanel,
					createdBy = HttpContext.Current.Session["ID"].ToString()
				});
			}

			tnx.Commit();
			return JsonConvert.SerializeObject(new { status = true, response = "Record Copied Successfully" });
		}
		catch (Exception ex)
		{
			tnx.Rollback();
			return JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", errorMessage = ex.Message });
		}
		finally
		{
			con.Close();
			con.Dispose();
		}
	}



	public class FPaneldisc
	{
		public int panelId { get; set; }
		public string categoryid { get; set; }
		public string subcategoryid { get; set; }
		public string itemId { get; set; }
		public decimal percentage { get; set; }
		public decimal IPDPercentage { get; set; }
		public int operationType { get; set; }
		public int patientTypeID { get; set; }
	}
    [WebMethod]
    public string bindReduceitemdetails(string reduceType, int panelid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ServiceName,SequenceNo,Reduce_per,IFNULL(Remarks,'')Remarks FROM Panelwise_Service_Reduce_Master WHERE ServiceName='" + reduceType + "' and Panelid ="+panelid+" AND Isactive=1");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    public class Servicereduce
    {
        public string ReduceType { get; set; }
        public string ReudceSequnce { get; set; }
        public string Reduceper { get; set; }
        public string Remarks { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public string saveServiceReduceDetails(List<Servicereduce> serviceReduce, string panelID)
    {   
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
               var UserID = HttpContext.Current.Session["ID"].ToString();
               var IsExit = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(*) FROM Panelwise_Service_Reduce_Master WHERE panelid=@panelID and ServiceName=@SericeName", CommandType.Text, new
               {
                   panelID = panelID,
                   SericeName = serviceReduce[0].ReduceType,  
               }));
               if (IsExit > 0)
               {
                   string sql = "update Panelwise_Service_Reduce_Master set isactive=0 , UpdatedBy=@UpdatedBy,UpdatedDateTime=NOW() where panelid=@panelID and ServiceName=@SericeName";
                   excuteCMD.DML(tnx, sql, CommandType.Text, new
                   {
                       UpdatedBy = UserID.ToString(),
                       panelID = Util.GetInt(panelID),
                       SericeName = serviceReduce[0].ReduceType,                       
                   });
               }
            serviceReduce.ForEach(i =>
            {
                if(i.Reduceper=="")
                {
                    i.Reduceper="0.00";
                }
                string sqlCMD = " INSERT INTO Panelwise_Service_Reduce_Master (ServiceName,SequenceNo,Reduce_per,EntryDateTime,Remarks,Panelid,EntryBy,IPAddress)Values(@ServiceName,@SequenceNo,@Reduce_per,NOW(),@Remarks,@Panelid,@EntryBy,@IPAddress);";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new {
                    ServiceName=i.ReduceType,
                    SequenceNo=i.ReudceSequnce,
                    Reduce_per=i.Reduceper,
                    Remarks=Util.GetString(i.Remarks),
                    Panelid = Util.GetInt(panelID),
                    EntryBy=UserID.ToString(),
                    IPAddress=All_LoadData.IpAddress(),
                });
            });
            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}