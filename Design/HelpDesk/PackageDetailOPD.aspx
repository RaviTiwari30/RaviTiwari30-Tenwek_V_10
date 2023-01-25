<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PackageDetailOPD.aspx.cs" Inherits="Design_HelpDesk_PackageDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
                               <script type="text/javascript" src="../../Scripts/Message.js"></script>

     <script type="text/javascript" >
         $(document).ready(function () {
             $("#ddlPackageName").chosen();
         });
        function packageDetail() {
             if ($("#ddlPackageName").val() == 0) {
                 $('#packageOutput').hide();
                 return false;
             }
            $('#lblErrormsg').text('');
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/packageDetail",
                data: '{packageID:"' + $("#ddlPackageName").val().split('#')[0] + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    package = jQuery.parseJSON(response.d);
                    if (package != null) {
                        var output = $('#tb_packageDetail').parseTemplate(package);
                        $('#packageOutput').html(output);
                        $('#packageOutput').show();
                    }
                    else {
                        DisplayMsg('MM04', 'lblErrormsg');
                        $('#packageOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
         var BindRate = function () {
             serverCall('../Common/CommonService.asmx/bindPackageRate', { PackageID: $("#ddlPackageName").val().split('#')[0], PanelID: '1', panelCurrencyFactor: '1' }, function (packageRate) {
                 var packageRateDetails = JSON.parse(packageRate);
                 $('#spnPackge').show();
                 $('#spnPackgeRate').show();
                 $('#spnPackgeRate').text(packageRateDetails[0].Rate);
             });
         }
        </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Package Detail</b>
            <br />

            <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; text-align: right">Package Name :&nbsp;</td>
                    <td style="width: 18%; ">
                        <asp:DropDownList ID="ddlPackageName" runat="server" ClientIDMode="Static" onchange="packageDetail();BindRate();"></asp:DropDownList></td>
                    <td style="width: 20%; text-align: right">
                    </td>
                    <td style="width: 20%;  text-align:right ">
                       <b><span id="spnPackge" style="font-size:large; display:none" class="patientInfo">Rate : </span></b> 
                        </td>
                    <td style="width: 25%;  text-align:left">
                        <b><span id="spnPackgeRate" style="font-size:large; display:none" class="patientInfo"></span></b> 
                    </td>

                </tr>
               </table>
            </div>
        <div class="POuter_Box_Inventory" style="text-align:center; display:none">
            <input type="button" class="ItDoseButton" value="Search" onclick="packageDetail()"/>
            </div>  
         <div class="POuter_Box_Inventory" style="text-align:center">
        <table border="0" style="width: 100%">
        <tr>
                    <td style="text-align:center" colspan="5">

                        <div id="packageOutput" style="max-height: 600px; overflow-x: auto;">
                        </div>

                    </td>

                </tr>
            </table>
             </div>
        </div>

    <script id="tb_packageDetail" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdpackage"
    style="width:950px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Package Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Valid From</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;  ">Valid To </th>		          
                                   <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Service Name</th>

		</tr>
        <#       
        var dataLength=package.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = package[j];
        #>
            

                    <tr id="<#=j+1#>" > 
                                                   
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                        <#
if(j>0)
  {
    if(package[j].PlabID!=package[j-1].PlabID)
    {#>    
                 <td class="GridViewLabItemStyle"  align="left" style="width:180px;" ><#=objRow.PackageName#></td> 
   <td class="GridViewLabItemStyle" id="tdPriority"  style="width:100px;text-align:center" ><#=objRow.FromDate#></td>
                    <td class="GridViewLabItemStyle" id="tdStatus"  style="width:90px;" ><#=objRow.ToDate#></td>
    <#}
    else
    {#>
   <td class="GridViewLabItemStyle" id="td1" align="left" style="width:40px;" >&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="td3"  style="width:100px;text-align:center" ></td>
                    <td class="GridViewLabItemStyle" id="td4"  style="width:90px;" ></td>
    <#}
  }
else
    {#>
    <td class="GridViewLabItemStyle" id="td2" align="left" style="width:180px;" ><#=objRow.PackageName#></td> 
                        <td class="GridViewLabItemStyle" id="td5"  style="width:100px;text-align:center" ><#=objRow.FromDate#></td>
                    <td class="GridViewLabItemStyle" id="td6"  style="width:90px;" ><#=objRow.ToDate#></td>
    <#}
    #>
                    <td class="GridViewLabItemStyle" id="tdTicketNo"  style="width:80px;text-align:center" ><#=objRow.Name#></td>
                    
                    
                                     
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>
</asp:Content>

