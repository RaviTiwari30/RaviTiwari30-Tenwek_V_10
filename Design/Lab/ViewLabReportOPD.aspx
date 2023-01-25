<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewLabReportOPD.aspx.cs" Inherits="Design_Lab_ViewLabReportOPD" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
        <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />

</head>
    
<body>
     <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript">
        var TID = "";
        $(function () {
            TID=   '<%=Request.QueryString["TransactionID"].ToString()%>';
            viewOPDLab();
        });
        function viewOPDLab() {
            $.ajax({
                url: "services/MapInvestigationObservation.asmx/ViewLabOPD",
                data: '{IPDNo:"' + TID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    OPDLabData = jQuery.parseJSON(result.d);
                    if (OPDLabData != null) {
                        var output = $('#tb_LabOPDSearch').parseTemplate(OPDLabData);
                        $('#LabOPDSearchOutput').html(output);
                        $('#LabOPDSearchOutput').show();                      
                        $("#spnError").text('');
                    }
                    else {
                        $('#LabOPDSearchOutput').html('');
                        $('#LabOPDSearchOutput').hide();
                        $("#spnError").text('Record Not Found');
                    }
                   
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#LabOPDSearchOutput').html();                 
                    $("#spnError").text('Error occurred, Please contact administrator');
                   
                }
            });
        }
    </script>
    <form id="form1" runat="server">
    <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
               
                    <b>Investigation Result</b>
                    <br />
                <span id="spnError" class="ItDoseLblError"></span>
                   
               
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <table  style="width: 100%;border-collapse:collapse">
                <tr >
                    <td colspan="4">
                        <div id="LabOPDSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                       
                    </td>
                </tr>
            </table>
                </div>

        </div>


        <script id="tb_LabOPDSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:800px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;text-align:center">S.No.</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;text-align:center">Department</th>          
			<th class="GridViewHeaderStyle" scope="col" style="width:420px;text-align:center">Investigations</th>        
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;text-align:center">Date</th>                    
		</tr>
        <#       
        var dataLength=OPDLabData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;         
        for(var j=0;j<dataLength;j++)
        {       
        objRow = OPDLabData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;text-align:center"><#=j+1#></td>                                    
                    <td class="GridViewLabItemStyle" id="tdDepartment"  style="width:160px;text-align:center"><#=objRow.Department#></td>
                    <td class="GridViewLabItemStyle" id="tdInvestigations"  style="width:420px;text-align:center"><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="tdDate"  style="width:100px;text-align:center"><#=objRow.DATE#></td>                                                   
                    </tr>           
        <#}        
        #>       
     </table>    
    </script>
    </form>
</body>
</html>
