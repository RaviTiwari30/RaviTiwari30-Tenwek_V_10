using System.Data;
using System.Text;

/// <summary>
/// Summary description for Machine
/// </summary>
public class Machine
{
	public Machine()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public DataTable MachineList(int CentreID)
    {
        return StockReports.GetDataTable("SELECT MachineID,REPLACE(Machinename,'_',' ')Machinename FROM " + AllGlobalFunction.MachineDB + ".`mac_machinemaster` WHERE CentreID=" + CentreID + ";");
    }

    public DataTable MachineParam(string MachineID)
    {
        return StockReports.GetDataTable("SELECT Machine_ParamID,IF(IFNULL(Machine_Param,'')='',Machine_ParamID,Machine_Param)Machine_Param,Suffix,AssayNo FROM " + AllGlobalFunction.MachineDB + ".mac_machineparam WHERE machineid='" + MachineID + "' ORDER BY Machine_Param,Machine_ParamID");
    }

    public DataTable BindMachineParam(string MachineID)
    {
        return StockReports.GetDataTable("select * from " + AllGlobalFunction.MachineDB + ".mac_machineparam where MachineID='" + MachineID + "' ");
    
    }
    public DataTable MachineParam(string MachineID,string Machine_ParamID)
    {
        return StockReports.GetDataTable("SELECT * FROM " + AllGlobalFunction.MachineDB + ".mac_machineparam WHERE MachineID='" + MachineID + "' and Machine_ParamID='" + Machine_ParamID + "'");
    }

    public string GetMachineCentreID(string MachineID)
    {
        return StockReports.ExecuteScalar("SELECT CentreID FROM " + AllGlobalFunction.MachineDB + ".`mac_machinemaster` WHERE MachineID='" + MachineID + "' ");
    }
    public DataTable AvailableMapping(string Machine_ParamID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.LabObservation_ID,lom.Name FROM Labobservation_master lom  ");
        sb.Append(" LEFT JOIN " + AllGlobalFunction.MachineDB + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID AND pm.Machine_ParamID='" + Machine_ParamID + "'  ");
        sb.Append(" WHERE lom.isProgrammed=1 AND pm.LabObservation_id IS NOT NULL ORDER BY TRIM(lom.Name) ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public DataTable PendingMapping(string Machine_ParamID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.LabObservation_ID,lom.Name FROM Labobservation_master lom  ");
        sb.Append(" LEFT JOIN " + AllGlobalFunction.MachineDB + ".mac_param_master pm ON pm.LabObservation_id=lom.LabObservation_ID AND pm.Machine_ParamID='" + Machine_ParamID + "'  ");
        sb.Append(" WHERE lom.isProgrammed=1 AND pm.LabObservation_id IS NULL ORDER BY TRIM(lom.Name) ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public void InsertMapping(string MachineID, string Machine_ParamID, string Alias, string LabObservation_ID, string EntryBy, string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" call " + AllGlobalFunction.MachineDB + ".insert_Mac_Param_Master('" + MachineID + "','" + Machine_ParamID + "','" + Alias + "','" + LabObservation_ID + "',1,'" + EntryBy + "'," + CentreID + ")");
        StockReports.ExecuteDML(sb.ToString());
    }

    public void DeleteMapping(string Machine_ParamID, string LabObservation_ID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" delete from " + AllGlobalFunction.MachineDB + ".mac_Param_Master where Machine_ParamID='" + Machine_ParamID + "' and  LabObservation_ID='" + LabObservation_ID + "'");
        StockReports.ExecuteDML(sb.ToString());
    }
    public string InserParam(string MachineParam, string Machine, string ParamAlias, string Suffix, string AssayNo, string RoundUpto, string IsOrderable, string MinLength, string CreatedBy, string CentreID)
    {
        StringBuilder sb = new StringBuilder("insert into " + AllGlobalFunction.MachineDB + ".mac_machineparam (Machine_paramID,Machine_param,MachineID,Suffix,AssayNo,RoundUpTo,isOrderable,MinLength,CreatedBy,CentreID) ");
        sb.Append("values('" + MachineParam + "','" + ParamAlias + "','" + Machine + "','" + Suffix + "','" + AssayNo + "','" + RoundUpto + "','" + IsOrderable + "','" + MinLength + "','" + CreatedBy + "'," + CentreID + ")");
        StockReports.ExecuteDML(sb.ToString());
        return "1";
    }
    public string UpdateParam(string Machine, string Machineparam, string ParamAlias, string Suffix, string AssayNo, string RoundUpto, string IsOrderable, string MinLength, string UpdatedBy, string CentreID)
    {
        StringBuilder sb = new StringBuilder("UPDATE " + AllGlobalFunction.MachineDB + ".mac_machineparam SET Machine_param='" + ParamAlias + "',Suffix='" + Suffix + "', ");
        sb.Append(" AssayNo='" + AssayNo + "',RoundUpTo='" + RoundUpto + "',isOrderable='" + IsOrderable + "',MinLength='" + MinLength + "',Updatedate=NOW(),UpdatedBy='" + UpdatedBy + "',CentreID=" + CentreID + " where Machine_paramID='" + Machineparam + "' AND MachineID='" + Machine + "'");
        StockReports.ExecuteDML(sb.ToString());
        return "1";
    }
    public string SaveMachine(string MachineID, string Machinename, string CreatedBy, string CentreID)
    {
        StockReports.ExecuteDML("INSERT INTO " + AllGlobalFunction.MachineDB + ".mac_machinemaster (MachineID,Machinename,CreatedBy,CreatedOn,CentreID) VALUES ('" + MachineID + "','" + Machinename + "','" + CreatedBy + "',NOW()," + CentreID + ")");
        return "1";
    }
}