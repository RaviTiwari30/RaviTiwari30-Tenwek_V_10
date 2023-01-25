<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelDetail.aspx.cs" Inherits="Design_HelpDesk_PanelDetail"  %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
                                   <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript" >
        function panelDetail() {
            $('#lblErrormsg').text('');

            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/panelSearch",
                data: '{Panel:"' + $("#ddlPanel").val() + '",PanelGroup:"' + $("#ddlPanelGroup").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    panel = jQuery.parseJSON(response.d);
                    if (panel != null) {
                        var output = $('#tb_panel').parseTemplate(panel);
                        $('#panelOutput').html(output);
                        $('#panelOutput').show();
                    }
                    else {
                        DisplayMsg('MM04', 'lblErrormsg');
                        $('#panelOutput').hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        $(document).ready(function () {
            $('#ddlPanel,#ddlPanelGroup').chosen();
        });


        </script>

    
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Panel Master<br />
                    </b>
                    <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            </div>
       
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Panel Details</div>
          <div class="row">
              <div class="col-md-3">
                  <label class="pull-left">Company Name</label>
                  <b class="pull-right">:</b>
              </div>
              <div class="col-md-5">
                  <asp:DropDownList ID="ddlPanel" runat="server"  ClientIDMode="Static"></asp:DropDownList>
              </div>
              <div class="col-md-3">
                  <label class="pull-left">Group Type</label>
                  <b class="pull-right">:</b>
              </div>
              <div class="col-md-5"><asp:DropDownList ID="ddlPanelGroup" runat="server"  ClientIDMode="Static"></asp:DropDownList></div>
              <div class="col-md-3"></div>
              <div class="col-md-5"><input type="button" value="Search" class="ItDoseButton" onclick="panelDetail()" /></div>
          </div>
           </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                View Existing Panel Details
            </div>
            <table style="width:100%">
                <tr>
                    <td style="text-align:center"  colspan="5">
                        <div id="panelOutput" style="max-height: 600px;width:100%; overflow-x: auto;"></div>
                    </td>
                </tr>
           </table>
        </div>
    </div>

  <script id="tb_panel" type="text/html">
    <table  cellspacing="0" rules="all" border="1" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:280px;">Company Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Ref-Rate(IPD) Company</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Ref-Rate(OPD) Company</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Contact Person</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Date From</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Date To</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">Credit Limit</th>
		</tr>
        <#       
        var dataLength=panel.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = panel[j];
        #>
            

                    <tr id="<#=j+1#>"> 
                                                 
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdName"  style="width:280px;text-align:center" ><#=objRow.Company_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdAddress"  style="width:300px;text-align:center" ><#=objRow.Add1#></td>
                    <td class="GridViewLabItemStyle" id="tdRefCompany"  style="width:100px;text-align:center" ><#=objRow.Ref_Company#></td>
                    <td class="GridViewLabItemStyle" id="tdRefCompanyOPD"  style="width:100px;text-align:center" ><#=objRow.Ref_CompanyOPD#></td>
                    <td class="GridViewLabItemStyle" id="tdContactPerson"  style="width:100px;text-align:center" ><#=objRow.Contact_Person#></td>
                    <td class="GridViewLabItemStyle" id="tdDateFrom"  style="width:100px;text-align:center" ><#=objRow.DateFrom#></td>
                    <td class="GridViewLabItemStyle" id="tdDateTo"  style="width:100px;text-align:center" ><#=objRow.DateTo#></td>
                    <td class="GridViewLabItemStyle" id="tdCreditLimit"  style="width:100px;text-align:center;display:none" ><#=objRow.CreditLimit#></td>

                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

</asp:Content>
