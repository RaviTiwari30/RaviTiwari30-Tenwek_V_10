<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="VenderReturn.aspx.cs" Inherits="Design_BloodBank_VenderReturn" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function displayValidationResult() {
            if (typeof (Page_Validators) == "undefined") return;
            var Reason = document.getElementById("<%=reqReason.ClientID%>");
            var LblName = document.getElementById("<%=lblReason.ClientID%>");
            ValidatorValidate(Reason);
            if (!Reason.isvalid) {
                LblName.innerText = Reason.errormessage;
                return false;
            }
        }
        var characterLimit = 200;
        $(document).ready(function () {
            $("#lblremaingCharacters").html(characterLimit);
            $("#<%=txtReason.ClientID %>").bind("keyup", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
        });
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                $("#divmessage").html("Maximum text length allowed is :" + charlimit);
            }
            else
                $("#divmessage").html("");
        }
        function BloodHistory() {
            $.ajax({
                url: "Services/VenderReturn.asmx/BloodHistory",
                data: '{ComponentID:"' + $("#ddlComponent").val() + '" }',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != "") {
                            var output = $('#tb_BloodSearch').parseTemplate(PatientData);
                            $('#BloodSearchOutput').html(output);
                            $('#BloodSearchOutput').show();
                            $('#divdata').show();
                        }
                    }
                    else {
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        $('#BloodSearchOutput').html();
                        $('#BloodSearchOutput').hide();
                        $('#divdata').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';
        }
        function DeleteRow(rowid) {
            var row = rowid;
            $("#<%=lblStockID.ClientID %>").text($(row).closest('tr').find("#tdStockID").html());
            $("#<%=lblComponentID.ClientID %>").text($(row).closest('tr').find("#tdComponentID").html());
            $("#<%=lblBloodCollectionId.ClientID %>").text($(row).closest('tr').find("#tdCollectionID").html());
            $("#<%=lblComponentName.ClientID %>").text($(row).closest('tr').find("#tdComponentName").html());
            $("#<%=lblTubeNo.ClientID %>").text($(row).closest('tr').find("#tdTubeNo").html());

            $find("mpBloodCancel").show();
        }
        function CancelBlood() {
            var Return = 0;
            if ($.trim($("#<%=txtReason.ClientID %>").val()) == "") {
                $("#<%=lblReason.ClientID %>").text('Please Enter Reason');
                Return = 1;
                return;
            }
            if (Return == "0") {
                var data = new Array();
                var obj = new Object();
                obj.StockID = $("#<%=lblStockID.ClientID %>").text();
                obj.ComponentID = $("#<%=lblComponentID.ClientID %>").text();
                obj.BloodCollectionId = $("#<%=lblBloodCollectionId.ClientID %>").text();
                obj.ComponentName = $("#<%=lblComponentName.ClientID %>").text();
                obj.TubeNo = $("#<%=lblTubeNo.ClientID %>").text();
                obj.Reason = $("#<%=txtReason.ClientID %>").val();
                data.push(obj);
                $.ajax({
                    url: "Services/VenderReturn.asmx/SaveVenderReturn",
                    data: JSON.stringify({ Data: data }),
                    type: "POST",
                    contentType: "application/json;charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            BloodHistory();
                            $find("mpBloodCancel").hide();
                            $("#<%=txtReason.ClientID %>").val('');
                            $("#<%=lblReason.ClientID %>").text('');
                            $("#<%=lblMsg.ClientID %>").text('Stock Return Succesfully');
                            $("#lblremaingCharacters").html('200');
                        }
                    },
                    error: function (xhr, status) {
                        var err = eval("(" + xhr.responseText + ")");
                        alert(err.Message);
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Vender Return</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlComponent" CssClass="requiredField">
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <input type="button" value="Search" onclick="BloodHistory();" class="ItDoseButton" />
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divdata" class="POuter_Box_Inventory" style="text-align: center; display:none;">
            <div class="Purchaseheader">
                History
            </div>
            <table  style="width: 100%; border-collapse:collapse">
                <tr>
                    <td colspan="4">
                        <div id="BloodSearchOutput">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <cc1:ModalPopupExtender ID="mpBloodCancel" runat="server" CancelControlID="btnCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlCancel" PopupDragHandleControlID="Div2" BehaviorID="mpBloodCancel">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlCancel" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
        Width="470px" Height="160px">
        <div class="Purchaseheader" id="Div2" runat="server">
            <strong>Cancel Reason</strong></div>
        <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 <asp:Label ID="lblReason" CssClass="ItDoseLblError" runat="server"></asp:Label>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">
                                Reason
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:TextBox ID="txtReason" runat="server" ValidationGroup="AddComplaint" Height="65px"
                        TextMode="MultiLine" Width="300px" MaxLength="200" onkeyup="javascript:ValidateCharactercount(200,this);"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="reqReason" runat="server" ControlToValidate="txtReason"
                        ErrorMessage="Please Enter Cancel Reason" SetFocusOnError="true" Display="None"
                        ValidationGroup="AddReason" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                             Number of Characters Left:
                    <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                    </label>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-8">
                        </div>
                        <div class="col-md-8">
                            <input type="button" value="Save" class="ItDoseButton" onclick="CancelBlood();" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false" />
                        </div>
                        <div class="col-md-8">
                        </div>
                    </div>
                </div>
            </div>
    </asp:Panel>
    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none" CssClass="ItDoseButton"/>
    <asp:Label ID="lblStockID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblComponentID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblBloodCollectionId" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblComponentName" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblTubeNo" runat="server" Style="display: none"></asp:Label>
    <script id="tb_BloodSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:100%;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Stock ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ComponentID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">BloodCollectionId</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;">Component Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Bag Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px; ">Batch No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Entry Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Return</th>
		</tr>
        <#
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdStockID" ><#=objRow.stock_ID#></td>
                     <td class="GridViewLabItemStyle" id="tdComponentID" style="width:40px;display:none" ><#=objRow.componentid#></td>
                    <td class="GridViewLabItemStyle" id="tdCollectionID" style="width:40px;display:none" ><#=objRow.BloodCollection_Id#></td>
                    <td class="GridViewLabItemStyle" id="tdComponentName" align="left"><#=objRow.componentname#></td>
                    <td class="GridViewLabItemStyle" id="tdBagType"><#=objRow.bagtype#></td>
                    <td class="GridViewLabItemStyle" id="tdTubeNo"><#=objRow.BBTubeNo#></td>
                    <td class="GridViewLabItemStyle" id="tdEntryDate"><#=objRow.EntryDate#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;">
                    <img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);"  onmouseover="chngcur()" title="Click To Cancel"/>
                    </td>
                    </tr>
        <#}#>
     </table>    
    </script>
</asp:Content>
