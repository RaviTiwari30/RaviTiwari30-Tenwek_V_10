<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewOrder.aspx.cs" Inherits="Design_IPD_ViewOrder" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <script type="text/javascript"  src="../../../Scripts/Search.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js" ></script>
    <script src="../../Scripts/jquery.extensions.js"  type="text/javascript"></script>
    <script type="text/javascript" src="../../../Scripts/Message.js" ></script>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
          <script type="text/javascript">
              $(document).ready(function () {
                  BindOrder();
              });
              function BindOrder() {
                  TID = '<%=Util.GetString(Request.QueryString["TransactionID"].ToString())%>';
                  $.ajax({
                  type: "POST",
                  url: "ViewOrder.aspx/BindOrder",
                  data: '{TransactionID:"' + TID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: true,
                success: function (response) {
                    Order = jQuery.parseJSON(response.d);
                    if (Order != null) {
                        var output = $('#tb_SearchOrder').parseTemplate(Order);
                        $('#OrderOutPut').html(output);
                        $('#OrderOutPut').show();
                        $("#lblMsg").text('');
                    }
                    else {
                        $('#OrderOutPut').hide();
                        $("#lblMsg").text('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

    </script>
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Patient Order Set Status </b>
                <asp:Label ID="lblMsg" runat="server" style="display:none"></asp:Label>
     <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                Patient Order Set Status
                </div>
         <table>
             <tr>
                <td style="width:30%;text-align:right">
                                 <b> Colour Status :</b>&nbsp;
                                </td>
                                <td style="border: thin solid black;background-color:lightpink;width:10%;height:10%; text-align:right"></td>
                                <td style="height: 8px;text-align:left">Order Issued
                                </td>
                  <td style="border: thin solid black;background-color:lightblue;width:10%;height:10%; text-align:right"></td>
                                <td style=" height: 8px;text-align:left">Not Issued (Because Patient Not Paid)
                                </td>
             </tr>
         </table>
         <div>
                <table style="width: 100%;font-family:Verdana;font-size:10pt" id="Medicines">
                        <tr>
                            <td class="auto-style1" style="text-align:right">
                                       
                            </td>
                            <td style="width:50%"></td>
                        </tr>
                        <tr>
                            <td class="auto-style1">
                                <div id="OrderOutPut">
                                </div>
                            </td>
                        </tr>
                        
                         
                         <tr>
                            <td class="auto-style1">&nbsp;</td>
                        </tr>
                    </table>
         </div>
     </div></div></div>
         <script id="tb_SearchOrder" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdOrder"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Order No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Doctor</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Created By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Create Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Issue By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Issue Date</th> 
		</tr>
        <#       
        var dataLength=Order.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = Order[j];
        #>
                    <tr id="<#=j+1#>"  
                        <#if(objRow.IsIssue=="1"){#>
                        style="background-color:lightpink"
                        <#}
                        else{#>
                        style="background-color:lightblue"
                        <#}
                        #>
                        >   
                         
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdAppNo"  style="width:50px;text-align:center" ><#=objRow.indent_No#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:160px;" ><#=objRow.TypeName#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientName" style="width:50px;"><#=objRow.Quantity#></td>
                    <td class="GridViewLabItemStyle" id="tdAge" style="width:100px;"><#=objRow.DrName#></td>
                    <td class="GridViewLabItemStyle" id="tdSex" style="width:160px;"><#=objRow.Remarks#></td>
                    <td class="GridViewLabItemStyle" id="tdAppointmentDate" style="width:80px;text-align:center"><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="tdVisitType" style="width:60px;"><#=objRow.Created_Date#></td>
                        <td class="GridViewLabItemStyle" id="td1" style="width:60px;"><#=objRow.IssueBy#></td>
                    <td class="GridViewLabItemStyle" id="tdDName" style="width:100px;"><#=objRow.Issue_Date#></td>
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>
    </form>
</body>
</html>
