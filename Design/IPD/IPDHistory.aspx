<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="IPDHistory.aspx.cs" Inherits="Design_IPD_IPDHistory" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
     <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    
</head>
<body>
    <form id="form1" runat="server">
        <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
      <script type="text/javascript">
          var PID;
          $(function () {
              PID = '<%=Util.GetString(Request.QueryString["PatientID"].ToString())%>';

          });
          $("document").ready(function () {
              bindPreviousVisit();
          });
      </script>
    
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
               
                    <b>IPD History</b><br />
                        <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    
                
            </div>
        
                         
                <table style="width:100%;border-collapse:collapse;display:none;">
                    <tr>
                        <td style="text-align: right; width: 20%;">
                            From Date :&nbsp;
                        </td>
                        <td style="text-align: left; width:30%;">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                                Width="129px" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right; width: 20%;">
                            To Date :&nbsp;
                        </td>
                        <td style="text-align: left;">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="129px"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    </table>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" tabindex="3" onclick="bindPreviousVisit()" style="display:none;" />
            </div>
        <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="OPDvisitOutPut">
                                  <div class="Purchaseheader" style="text-align: left;">
                   IPD History
                </div>
                                <div id="VisitOutPut"  style="vertical-align:top;height:200px;">
                                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">



        function bindPreviousVisit() {

            $.ajax({
                url: "OPDHistory.aspx/bindPreviousVisit",
                data: '{PID:"' + PID + '",fromDate:"' + $('#txtFromDate').val() + '",toDate:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    Visit = jQuery.parseJSON(mydata.d);
                    if (Visit != null) {
                        var output = $('#tb_PreviousVisit').parseTemplate(Visit);
                        $('#VisitOutPut').html(output);
                        $('#VisitOutPut,#PreviousVisit,#OPDvisitOutPut').show();
                        $('#lblMsg').text('');
                    }
                    else {
                        $('#VisitOutPut,#PreviousVisit,#OPDvisitOutPut').hide();
                        $('#lblMsg').text('No History Found');

                    }
                }
            });
        }
    </script>
     <script id="tb_PreviousVisit" type="text/html">
                     <table  cellspacing="0" rules="all" border="1" 
    style="border-collapse:collapse;width:100%"  class="GridViewStyle">
		<tr id="Header">
			
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Consultation Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none">DoctorID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none">TID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none">LedgerTransactionNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">View History</th>
		</tr>
        <#       
        var dataLength=Visit.length;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = Visit[j];
        #>
           

                     <tr id="<#=j+1#>"  style="cursor:pointer;"   >                                                                                                       
                                                                                                                          
                   
                    <td   class="GridViewLabItemStyle"  id="tdVisitDate" style="width:100px;text-align:center" ><#=objRow.DateVisit#></td>
                    <td   class="GridViewLabItemStyle" id="tdDName" style="width:240px; text-align:center;">
                       <#=objRow.DName#>
                        </td>
                    <td   class="GridViewLabItemStyle" id="tdDoctorID" style=" text-align:center; display:none">
                       <#=objRow.DoctorID#>
                        </td>
<td   class="GridViewLabItemStyle" id="tdTransactionID" style=" text-align:center; display:none">
                       <#=objRow.TransactionID#>
                        </td>
                         <td   class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style=" text-align:center; display:none">
                       <#=objRow.LedgerTransactionNo#>
                        </td>
                        <td class="GridViewLabItemStyle" style="width:40px;text-align:center">
                          
                            <input type="button" class="ItDoseButton" value="View"  onclick="Print(this)"/>
                            
                            
                        </td>
                    </tr>           
        <#}       
        #>       
     </table>   </script> 
   <script type="text/javascript">
       function Print(rowid) {
           var TID = $.trim($(rowid).closest('tr').find("#tdTransactionID").text());
           var LnxNo = $.trim($(rowid).closest('tr').find("#tdLedgerTransactionNo").text());
           location.href = '../CPOE/PrintOut.aspx?TID=' + TID + '&LnxNo=' + LnxNo + ' ';
       }
    </script>
</body>
</html>