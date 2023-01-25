<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UpdatePatientDischarge.aspx.cs"
    Inherits="Design_IPD_UpdatePatientDischarge" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
     
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Update Patient Discharge</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <span id="spnTID" style="display: none"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="col-md-7"></div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            IPD No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtCRNo" runat="server" Width="95%" ClientIDMode="Static" MaxLength="10"
                            ToolTip="Enter IPD No." AutoCompleteType="Disabled"></asp:TextBox>
                        <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        
                    </div>
                    <div class="col-md-7"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td></td>
                    <td style="text-align: center">


                        <input type="button" value="Search"
                             id="btnSearch" title="Click to Search" onclick="searchDischarge()" class="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlHide" runat="server" ClientIDMode="Static" Style="display: none">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Patient Details
                </div>

                <table style="width: 100%; border-collapse: collapse" id="myTable">
                    <tr>
                        <td colspan="4">
                            <div id="DischargeSearchOutput" style="max-height: 500px; overflow-x: auto;">
                            </div>
                            <br />
                        </td>
                    </tr>
                </table>
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                       <div class="col-md-7"></div>
                         <div class="col-md-3">
                            <label class="pull-left">
                               <asp:Label ID="lblDischarge" ClientIDMode="Static" runat="server" Style="display: none" Text="Discharge Type"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:DropDownList ID="cmbDischargeType" ClientIDMode="Static" Style="display: none" runat="server">
                          </asp:DropDownList>
                        </div>
                         <div class="col-md-2">
                             <input type="button" value="Save" id="btnSave"  onclick="saveDischargeType()" class="ItDoseButton"
                                 style="display: none;margin-top:0px;" />
                         </div>
                        <div class="col-md-7"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            </div>
          
        </asp:Panel>
    </div>
    <script id="tb_DischargeSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IPD No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Discharge Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px; display:none">TID </th>
		</tr>
        <#
        var dataLength=DischargeData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;
       
     
        for(var j=0;j<dataLength;j++)
        {
        objRow = DischargeData[j];
        #>
                    <tr id="<#=j+1#>">                  
                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:100px;text-align:left" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:120px;"><#=objRow.TransNo.replace("","")#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:140px;"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdAddress" style="width:140px;"><#=objRow.Address#></td>
                    <td class="GridViewLabItemStyle" id="tdDischargeType" style="width:80px;"><#=objRow.DischargeType#></td>
                    <td class="GridViewLabItemStyle" id="tdTID" style="width:80px; display:none"><#=objRow.TransactionID#></td>
                    </tr>
        <#}
        #>
       
     </table>
    </script>
    <script type="text/javascript">
        function searchDischarge() {
            if ($("#txtCRNo").val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter IPD No.');
                $("#txtCRNo").focus();
                return false;
            }
            var TID = $("#txtCRNo").val();
            $.ajax({
                url: "Services/IPD.asmx/dischargeType",
                data: '{TID:"' + TID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    DischargeData = jQuery.parseJSON(result.d);
                    if (DischargeData != null) {
                        var output = $('#tb_DischargeSearch').parseTemplate(DischargeData);
                        $('#DischargeSearchOutput').html(output);
                        $('#DischargeSearchOutput,#btnSave,#lblDischarge,#cmbDischargeType,#pnlHide').show();
                        $("#<%=lblMsg.ClientID%>").text('');
                        $("#tb_grdSearch tr").each(function () {
                            $("#cmbDischargeType option:contains(" + $(this).find('#tdDischargeType').html() + ")").attr('selected', 'selected');
                            $("#spnTID").text($(this).find('#tdTID').html());
                        });
                    }
                    else {
                        $('#DischargeSearchOutput').html();
                        $('#DischargeSearchOutput,#btnSave,#lblDischarge,#cmbDischargeType,#pnlHide').hide();
                        $("#<%=lblMsg.ClientID%>").text('Record Not Found');
                        $("#spnTID").text('');
                    }

                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                    $('#DischargeSearchOutput').html();
                    $('#DischargeSearchOutput,#btnSave,#lblDischarge,#cmbDischargeType,#pnlHide').hide();
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    $("#spnTID").text('');
                }
            });
        }

        function saveDischargeType() {

            $.ajax({
                url: "Services/IPD.asmx/changeDischargeType",
                data: '{TID:"' + $("#spnTID").text() + '",DischargeType:"' + $("#cmbDischargeType option:selected").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = result.d;
                    if (Data == true)
                        $("#<%=lblMsg.ClientID%>").text('Record Updated Successfully');
                    else
                        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');

                    $("#spnTID").text(''); $("#txtCRNo").val('');
                    $('#DischargeSearchOutput').html('');
                    $('#DischargeSearchOutput,#btnSave,#lblDischarge,#cmbDischargeType,#pnlHide').hide();
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                    $('#DischargeSearchOutput').html();
                    $('#DischargeSearchOutput,#btnSave,#lblDischarge,#cmbDischargeType,#pnlHide').hide();
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    $("#spnTID").text('');
                }
            });

        }
    </script>
</asp:Content>
