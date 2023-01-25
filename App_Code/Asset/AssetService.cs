using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Web;

[ServiceContract]
[AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
public class AssetService
{
    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveGroup(string GroupCode, string GroupName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AssetGroup ag = new AssetGroup(tnx);
            ag.GroupCode = GroupCode;
            ag.GroupName = GroupName;
            ag.CreatedBy = HttpContext.Current.Session["ID"].ToString();
            ag.Insert();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindGroupDetail()
    {
        DataTable dtGroup = StockReports.GetDataTable("SELECT GroupID,GroupName,GroupCode,if(IsActive=1,'Yes','No')IsActive FROM ass_groupmaster ");
        if (dtGroup.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtGroup);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateGroup(int GroupID, string GroupCode, string GroupName, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AssetGroup ag = new AssetGroup(tnx);
            ag.GroupID = GroupID;
            ag.GroupCode = GroupCode;
            ag.GroupName = GroupName;
            ag.IsActive = IsActive;
            ag.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [FaultContract(typeof(ServiceData))]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindGroup()
    {
        DataTable group = StockReports.GetDataTable("SELECT GroupID,GroupName FROM ass_groupmaster WHERE IsActive=1");
        if (group.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(group);
        else
            return "";
    }

    [DataContract]
    public class ServiceData
    {
        [DataMember]
        public bool Result { get; set; }

        [DataMember]
        public string ErrorMessage { get; set; }

        [DataMember]
        public string ErrorDetails { get; set; }
    }

    [OperationContract(Name = "bindSubGroup")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindSubGroup(string GroupID)
    {
        DataTable subGroup = StockReports.GetDataTable("SELECT SubGroupID,SubGroupName FROM ass_SubGroupMaster WHERE IsActive=1 And GroupID='" + GroupID + "'");
        if (subGroup.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(subGroup);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindSubGroupDetail()
    {
        DataTable group = StockReports.GetDataTable("SELECT gm.GroupID,gm.GroupName,gm.GroupCode,sgm.SubGroupID,sgm.SubGroupName,sgm.SubGroupCode,if(sgm.IsActive=1,'Yes','No')IsActive FROM ass_groupmaster gm INNER JOIN ass_SubGroupMaster sgm ON gm.GroupID=sgm.GroupID ");
        if (group.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(group);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveSubGroup(int GroupID, string SubGroupName, string SubGroupCode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AssetSubGroup asg = new AssetSubGroup(tnx);
            asg.GroupID = GroupID;
            asg.SubGroupName = SubGroupName;
            asg.SubGroupCode = SubGroupCode;
            asg.CreatedBy = HttpContext.Current.Session["ID"].ToString();
            asg.Insert();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateSubGroup(int subGroupID, int GroupID, string SubGroupName, string SubGroupCode, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AssetSubGroup asg = new AssetSubGroup(tnx);
            asg.SubGroupID = subGroupID;
            asg.GroupID = GroupID;
            asg.SubGroupName = SubGroupName;
            asg.SubGroupCode = SubGroupCode;
            asg.IsActive = IsActive;
            asg.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindAssetDetail()
    {
        DataTable asset = StockReports.GetDataTable("SELECT gm.GroupID,gm.GroupName,gm.GroupCode,sgm.SubGroupID, " +
            " sgm.SubGroupName,sgm.SubGroupCode,if(asm.IsActive=1,'Yes','No')IsActive,asm.AssetID,asm.AssetName,asm.AssetCode FROM ass_groupmaster gm " +
            " INNER JOIN ass_SubGroupMaster sgm ON gm.GroupID=sgm.GroupID INNER JOIN ass_assetmaster asm ON asm.GroupID=gm.GroupID WHERE gm.IsActive=1 AND sgm.IsActive=1 ");
        if (asset.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(asset);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveAsset(int GroupID, int SubGroupID, string AssetName, string AssetCode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AssetMaster am = new AssetMaster(tnx);
            am.GroupID = GroupID;
            am.SubGroupID = SubGroupID;
            am.AssetName = AssetName;
            am.AssetCode = AssetCode;
            am.CreatedBy = HttpContext.Current.Session["ID"].ToString();
            am.Insert();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateAsset(int AssetID, int GroupID, int SubGroupID, string AssetCode, string AssetName, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AssetMaster am = new AssetMaster(tnx);
            am.AssetID = AssetID;
            am.GroupID = GroupID;
            am.SubGroupID = SubGroupID;
            am.AssetCode = AssetCode;
            am.AssetName = AssetName;
            am.IsActive = IsActive;
            am.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindAsset()
    {
        DataTable asset = StockReports.GetDataTable("Select AssetID,AssetName FROM ass_assetmaster WHERE IsActive=1");
        if (asset.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(asset);
        else
            return "";
    }

    [OperationContract(Name = "bindSubGroupAsset")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindSubGroup()
    {
        DataTable subGroup = StockReports.GetDataTable("Select SubGroupID,SubGroupName FROM ass_SubGroupMaster WHERE IsActive=1");
        if (subGroup.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(subGroup);
        else
            return "";
    }

    [OperationContract(AsyncPattern = false)]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindDisposalMethod()
    {
        DataTable disposal = StockReports.GetDataTable("Select DisposalID,DisposalName FROM ass_DisposalMaster WHERE IsActive=1");
        if (disposal.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(disposal);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveAssetStock(List<AssetStock> dataAsset)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < dataAsset.Count; i++)
            {
                AssetStock ast = new AssetStock(tnx);

                ast.AssetID = dataAsset[0].AssetID;
                ast.AssetName = dataAsset[0].AssetName;
                ast.AssetPurchaseDate = Util.GetDateTime(dataAsset[0].AssetPurchaseDate).ToString("yyyy-MM-dd");
                ast.AMCStartDate = Util.GetDateTime(dataAsset[0].AMCStartDate).ToString("yyyy-MM-dd");
                ast.AMCEndDate = Util.GetDateTime(dataAsset[0].AMCEndDate).ToString("yyyy-MM-dd");
                ast.Batch_Serial_Con = dataAsset[0].Batch_Serial_Con;
                ast.Quantity = Util.GetDecimal(dataAsset[0].Quantity);
                ast.Asset_Con = dataAsset[0].Asset_Con;
                ast.AssetValue = Util.GetDecimal(dataAsset[0].AssetValue);
                ast.Remarks = dataAsset[0].Remarks;
                ast.GRNNo = dataAsset[0].GRNNo;
                ast.GRNDate = Util.GetDateTime(dataAsset[0].GRNDate).ToString("yyyy-MM-dd");
                ast.InvoiceNo = dataAsset[0].InvoiceNo;
                ast.InvoiceDate = Util.GetDateTime(dataAsset[0].InvoiceDate).ToString("yyyy-MM-dd");
                ast.WarrantyNo = dataAsset[0].WarrantyNo;
                ast.WarrantyDate = Util.GetDateTime(dataAsset[0].WarrantyDate).ToString("yyyy-MM-dd");
                ast.LeaseNo = dataAsset[0].LeaseNo;
                ast.LeaseDate = Util.GetDateTime(dataAsset[0].LeaseDate).ToString("yyyy-MM-dd");
                ast.DisposalDate = Util.GetDateTime(dataAsset[0].DisposalDate).ToString("yyyy-MM-dd");
                ast.DisposalMethod = dataAsset[0].DisposalMethod;
                ast.DisposalMethodID = dataAsset[0].DisposalMethodID;
                ast.DepreciationMethod = dataAsset[0].DepreciationMethod;
                ast.Salvage = Util.GetDecimal(dataAsset[0].Salvage);
                ast.DepreciationLife = Util.GetDateTime(dataAsset[0].DepreciationLife).ToString("yyyy-MM-dd"); ;
                ast.DepreciationRate = Util.GetDecimal(dataAsset[0].DepreciationRate);
                ast.BarCode = dataAsset[i].BarCode;
                ast.BatchNo = dataAsset[i].BatchNo;
                ast.SerialNo = dataAsset[i].SerialNo;
                ast.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                ast.AMCTypeID = dataAsset[0].AMCTypeID;
                ast.DeptLedgerNo = HttpContext.Current.Session["DeptLedgerNo"].ToString();
                ast.Insert();
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract(AsyncPattern = false)]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindMaintenanceDetail()
    {
        DataTable maintenance = StockReports.GetDataTable("Select MaintenanceID,MaintenanceCode,MaintenanceName,if(IsActive=1,'Yes','No')IsActive FROM ass_MaintenanceMaster ");
        if (maintenance.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(maintenance);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveMaintenance(string MaintenanceCode, string MaintenanceName)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) FROM ass_maintenancemaster WHERE MaintenanceName='" + MaintenanceName + "'"));
        if (count > 0)
        {
            return "2";
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MaintenanceMaster mm = new MaintenanceMaster(tnx);
                mm.MaintenanceCode = MaintenanceCode;
                mm.MaintenanceName = MaintenanceName;
                mm.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                mm.Insert();

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateMaintenance(int MaintenanceID, string MaintenanceCode, string MaintenanceName, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MaintenanceMaster mm = new MaintenanceMaster(tnx);
            mm.MaintenanceID = MaintenanceID;
            mm.MaintenanceCode = MaintenanceCode;
            mm.MaintenanceName = MaintenanceName;
            mm.IsActive = IsActive;
            mm.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindProblemDetail()
    {
        DataTable problem = StockReports.GetDataTable("SELECT ProblemID,ProblemCode,ProblemName,if(IsActive=1,'Yes','No')IsActive FROM ass_problemMaster ");

        if (problem.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(problem);
        else
            return "";
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveProblem(string ProblemCode, string ProblemName)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) FROM ass_Problemmaster WHERE ProblemName='" + ProblemName + "'"));
        if (count > 0)
        {
            return "2";
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                ProblemMaster pm = new ProblemMaster(tnx);
                pm.ProblemCode = ProblemCode;
                pm.ProblemName = ProblemName;
                pm.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                pm.Insert();

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    [OperationContract]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateProblem(int ProblemID, string ProblemCode, string ProblemName, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ProblemMaster pm = new ProblemMaster(tnx);
            pm.ProblemID = ProblemID;
            pm.ProblemCode = ProblemCode;
            pm.ProblemName = ProblemName;
            pm.IsActive = IsActive;
            pm.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract(Name = "bindCallTypeDetail")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindCallTypeDetail()
    {
        DataTable callType = StockReports.GetDataTable("SELECT CallTypeID,CallTypeName,CallTypeCode,if(IsActive=1,'Yes','No')IsActive FROM ass_callTypeMaster ");

        if (callType.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(callType);
        else
            return "";
    }

    [OperationContract(Name = "saveCallType")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveCallType(string CallTypeCode, string CallTypeName)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) FROM ass_callTypeMaster WHERE CallTypeName='" + CallTypeName + "'"));
        if (count > 0)
        {
            return "2";
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                CallTypeMaster ct = new CallTypeMaster(tnx);

                ct.CallTypeCode = CallTypeCode;
                ct.CallTypeName = CallTypeName;
                ct.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                ct.Insert();

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    [OperationContract(Name = "updateCalltype")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateCalltype(int CallTypeID, string CallTypeCode, string CallTypeName, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            CallTypeMaster ct = new CallTypeMaster(tnx);
            ct.CallTypeID = CallTypeID;
            ct.CallTypeCode = CallTypeCode;
            ct.CallTypeName = CallTypeName;
            ct.IsActive = IsActive;
            ct.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract(Name = "bindAMCDetail")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindAMCDetail()
    {
        DataTable amc = StockReports.GetDataTable("SELECT AMCTypeID,AMCName,AMCCode,Address,ContactNo,Country,City,EmailID,FaxNo,AMCDuedays,ContactPerson_1, " +
        " ContactPersonContctNo_1,ContactPersonDesignation_1,ContactPersonEmailID_1,ContactPerson_2,ContactPersonContctNo_2,ContactPersonDesignation_2,ContactPersonEmailID_2,if(IsActive=1,'Yes','No')IsActive FROM ass_amcTypeMaster ");

        if (amc.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(amc);
        else
            return "";
    }

    [OperationContract(Name = "saveAMCType")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string saveAMCType(string AMCName, string AMCCode, string Address, string ContactNo, string Country, string City, string EmailID, string FaxNo, string AMCDuedays, string ContactPerson1, string ContactPersonContctNo1, string ContactPersonDesignation1, string ContactPersonEmailID1, string ContactPerson2, string ContactPersonContctNo2, string ContactPersonDesignation2, string ContactPersonEmailID2)
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) FROM ass_amctypemaster WHERE AMCName='" + AMCName + "'"));
        if (count > 0)
        {
            return "2";
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                AMCTypeMaster amc = new AMCTypeMaster(tnx);

                amc.AMCName = AMCName;
                amc.AMCCode = AMCCode;
                amc.Address = Address;
                amc.ContactNo = ContactNo;
                amc.Country = Country;
                amc.City = City;
                amc.EmailID = EmailID;
                amc.FaxNo = FaxNo;
                amc.AMCDuedays = AMCDuedays;
                amc.ContactPerson_1 = ContactPerson1;
                amc.ContactPersonContctNo_1 = ContactPersonContctNo1;
                amc.ContactPersonDesignation_1 = ContactPersonDesignation1;
                amc.ContactPersonEmailID_1 = ContactPersonEmailID1;
                amc.ContactPerson_2 = ContactPerson2;
                amc.ContactPersonContctNo_2 = ContactPersonContctNo2;
                amc.ContactPersonDesignation_2 = ContactPersonDesignation2;
                amc.ContactPersonEmailID_2 = ContactPersonEmailID2;
                amc.CreatedBy = HttpContext.Current.Session["ID"].ToString();
                amc.Insert();

                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    [OperationContract(Name = "updateAMCtype")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string updateAMCtype(int AMCTypeID, string AMCName, string AMCCode, string Address, string ContactNo, string Country, string City, string EmailID, string FaxNo, string AMCDuedays, string ContactPerson_1, string ContactPersonContctNo_1, string ContactPersonDesignation_1, string ContactPersonEmailID_1, string ContactPerson_2, string ContactPersonContctNo_2, string ContactPersonDesignation_2, string ContactPersonEmailID_2, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            AMCTypeMaster amc = new AMCTypeMaster(tnx);
            amc.AMCTypeID = AMCTypeID;
            amc.AMCName = AMCName;
            amc.AMCCode = AMCCode;
            amc.Address = Address;
            amc.ContactNo = ContactNo;
            amc.Country = Country;
            amc.City = City;
            amc.EmailID = EmailID;
            amc.FaxNo = FaxNo;
            amc.AMCDuedays = AMCDuedays;
            amc.ContactPerson_1 = ContactPerson_1;
            amc.ContactPersonContctNo_1 = ContactPersonContctNo_1;
            amc.ContactPersonDesignation_1 = ContactPersonDesignation_1;
            amc.ContactPersonEmailID_1 = ContactPersonEmailID_1;
            amc.ContactPerson_2 = ContactPerson_2;
            amc.ContactPersonContctNo_2 = ContactPersonContctNo_2;
            amc.ContactPersonDesignation_2 = ContactPersonDesignation_2;
            amc.ContactPersonEmailID_2 = ContactPersonEmailID_2;
            amc.IsActive = IsActive;
            amc.Update();

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [OperationContract(Name = "bindAMCType")]
    [WebInvoke(Method = "POST", ResponseFormat = WebMessageFormat.Json)]
    public string bindAMCType()
    {
        DataTable amc = StockReports.GetDataTable("SELECT AMCTypeID,AMCName  FROM ass_amcTypeMaster WHERE IsActive=1 ");
        if (amc.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(amc);
        else
            return "";
    }
}