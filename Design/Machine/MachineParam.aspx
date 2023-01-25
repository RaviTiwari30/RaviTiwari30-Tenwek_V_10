<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineParam.aspx.cs" Inherits="Design_Machine_MachineParam" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <script type="text/javascript" src="../../Scripts/Search.js"></script>  
    <script type="text/javascript" >
     function validatespace() {
            var card = $('#<%=txtAlias.ClientID %>').val();
             if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                 $('#<%=txtAlias.ClientID %>').val('');
                 modelAlert('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                // $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }

     }
        
        $(function () {
            $('.ddlselect').chosen();
            var EmployeeID = '<%=Session["ID"].ToString() %>';
            if (EmployeeID == "EMP001") {
                $('.admin').show();
            }
            else
                $('.admin').hide();

            $("#btnAddParam").click(function () {
                var machineId = $("#ddlMachine").val();
                if (machineId != 0) {
                    Clear();
                    $('#popup').showModel();;
                    $("#txtmachineid").val(machineId);
                    $("#txtmachineparam").val(machineId +"_");
                }
                else {
                    modelAlert("Please Select Machine Name", function () {
                        $("#ddlMachine").focus();
                    });
                }
            });
            $("#btnNewMachine").click(function () {
                Clear();
                $('#divAddMachine').showModel();
            });
            $("#btnsaveparam").click(function () {
                var MachineParam = $("#txtmachineparam").val();
                var Machine = $("#txtmachineid").val();
                var ParamAlias = $("#txtparam").val();
                var Suffix = $("#txtsuffix").val();
                var AssayNo = $("#txtassay").val();
                var RoundUpto = $("#txtround").val();
                var IsOrderable = $("#chkorder").attr("checked") ? 1 : 0;
                var MinLength = $("#txtmin").val();
                if (Machine != "" && MachineParam != "") {
                    $.ajax({
                        url: "Machineparam.aspx/Savedetails",
                        data: JSON.stringify({ MachineParam: MachineParam, Machine: Machine, ParamAlias: ParamAlias, Suffix: Suffix, AssayNo: AssayNo, RoundUpto: RoundUpto, IsOrderable: IsOrderable, MinLength: MinLength }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        async: false,
                        dataType: "json",
                        cache: false,
                        success: function (result) {
                            var obj = result.d;
                            if (obj == '1') {
                                Clear();
                                $('#popup').closeModel();
                                modelAlert("Details Submitted Successfully");
                            }
                            else {
                                modelAlert('Machine Param ID already exits');
                            }
                        }
                    });
                }
                else { modelAlert("Please enter the Machine Param and Machine Param Alias"); }
            });
        });
        $('#btncancel').click(function () {
            $('#popup').closeModel();
        });

        $("#btnModify").click(function () {
            Clear();
            $('#modifiedpop').showModel();
        });
        $(function () {
            $("#btnModify").click(function () {
                Clear();
                $('#modifiedpop').showModel();
                BindMachine();
            });
        });
        $(document).ready(function () {
       
        });
        function loaddetail() {
                    $("#txtparamalias").val($("#ddlparam").val().split('^')[1]);
                    $("#txtsufix").val($("#ddlparam").val().split('^')[2]);
                    $("#txtassayno").val($("#ddlparam").val().split('^')[3]);
                    $("#txtroundup").val($("#ddlparam").val().split('^')[4]);
                    $("#txtminlength").val($("#ddlparam").val().split('^')[6]);
                    if ($("#ddlparam").val().split('^')[5] == "1")
                        $("#chkord").attr("checked", "checked");
                    else
                        $("#chkord").attr("checked", false);
            
        }
        function BindMachine() {
            var Machine = $("#ddlmachinebind")
            $('#ddlmachinebind option').remove();
            $.ajax({
                url: "Machineparam.aspx/BindMachine",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    var Data = jQuery.parseJSON(result.d);
                    if (Data != null) {
                        Machine.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            Machine.append($("<option></option>").val(Data[i].MachineID).html(Data[i].Machinename));
                        }
                        Machine.chosen();
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }
        function BindMachineParam()
        {
            var MachineId = $("#ddlmachinebind").val();
            $('#ddlparam option').remove();
            $.ajax({
                url: "Machineparam.aspx/BindMachineParams",
                data: JSON.stringify({ MachineId: MachineId }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                   var Data = jQuery.parseJSON(result.d);
                   if (Data != null) {
                       $("#ddlparam").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Data.length; i++) {
                            $("#ddlparam").append($("<option></option>").val(Data[i].Machine_ParamID + "^" + Data[i].Machine_Param + "^" + Data[i].Suffix + "^" + Data[i].AssayNo + "^" + Data[i].RoundUpTo + "^" + Data[i].IsOrderable + "^" + Data[i].MinLength).html(Data[i].Machine_ParamID));
                        }
                        $("#ddlparam").chosen();
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }
        $(function () {
            $("#btnupdate").click(function () {
                var Machine = $("#ddlmachinebind").val();
                var Machineparam = $("#ddlparam").val().split('^')[0];
                var ParamAlias = $("#txtparamalias").val();
                var Suffix = $("#txtsufix").val();
                var AssayNo = $("#txtassayno").val();
                var RoundUpto = Number($("#txtround").val()) == "0" ? 0 : Number($("#txtround").val());
                var IsOrderable = $("#chkord").attr("checked") ? 1 : 0;
                var MinLength = Number($("#txtminlength").val()) == "0" ? 0 : Number($("#txtminlength").val());
                $.ajax({
                    url: "Machineparam.aspx/UpdateDetail",
                    data: JSON.stringify({ Machine: Machine, Machineparam: Machineparam, ParamAlias: ParamAlias, Suffix: Suffix, AssayNo: AssayNo, RoundUpto: RoundUpto, IsOrderable: IsOrderable, MinLength: MinLength }),
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        var obj = result.d;
                        if (obj == '1') {
                            Clear();
                            BindMachine();
                            BindMachineParam();
                            $('#modifiedpop').closeModel();
                            modelAlert('Machine Parameter Updated Successfully.', function () { });

                        }
                        else {
                            modelAlert('Machine Param ID Already Exits.');
                        }

                    }
                });
            });
            $('#btnSaveMachine').click(function () {
                var MachineName = $("#txtMachineName").val();
                var MachineAlias = $("#txtMachineAlias").val();
                if (ValidationMachineSave() == true) {
                    modelConfirmation('Machine Create.', 'Do you want to create the machine on' +":->"+ '<%=Session["CentreName"].ToString()%>' + '?', 'Yes', 'No', function (response) {
                        if (response) {
                            $.ajax({
                                url: "Machineparam.aspx/SaveMachine",
                                data: JSON.stringify({ MachineName: MachineName, MachineAlias: MachineAlias }),
                                type: "POST",
                                contentType: "application/json; charset=utf-8",
                                timeout: 120000,
                                async: false,
                                dataType: "json",
                                cache: false,
                                success: function (result) {
                                    var obj = result.d;
                                    if (obj == '1') {
                                        Clear();
                                        $('#divAddMachine').closeModel();
                                        modelAlert('Machine Saved Successfully');
                                    }
                                    else {
                                        modelAlert('Machine Name already exits');
                                    }
                                }
                            });
                        }
                    });
                }
                else { modelAlert('Machine Name Or Machine Alias already exits'); }
            });
        });
        function ValidationMachineSave() {
            if ($("#txtMachineName").val() == "")
            {
                modelAlert('Machine Name Can Not Be blank', function () { $("#txtMachineName") .focus()});
                return false;
            }
            if ($("#txtMachineAlias").val() == "") {
                modelAlert('Machine Alias Name Can Not Be blank', function () { $("#txtMachineAlias").focus() });
                return false;
            }
            return true;
        }
        function Clear() {
            $('#txtmachineid').val('');
            $('#txtmachineparam').val('');
            $('#txtparamalias').val('');
            $('#txtsufix').val('');
            $('#txtassayno').val('');
            $('#txtround').val('');
            $('#txtminlength').val('');
            $('#txtmachineid').val('');
            $('#txtmachineparam').val('');
            $('#txtparam').val('');
            $('#txtsuffix').val('');
            $('#txtassay').val('');
            $('#txtparam').val('');
            $("#chkord").attr("checked", false);
            $("#chkorder").attr("checked", false);
            $("#txtMachineName").val('');
            $("#txtMachineAlias").val('');
            $("#ddlmachinebind").val('0');
            $("#ddlparam").val('0');
        }
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function CheckMachineSync() {
            modelConfirmation('Sync Machine Mapping', 'Do you want to Sync the Machine Mapping of' + " " + '<%=Session["CentreName"].ToString()%>' + '?', 'Yes', 'No', function (response) {
                if (response) {
                    serverCall('MachineParam.aspx/SyncData', {}, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.message, function () {

                        });
                    });
                }
            });
            return false;
        }
       </script>

    
  <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
  
     </Ajax:ScriptManager>

<div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Machine Mapping</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="col-md-1"></div>
                <div class="col-md-22">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Machine ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="ddlMachine" CssClass="ddlselect" runat="server"  AutoPostBack="True" ClientIDMode="Static" OnSelectedIndexChanged="ddlMachine_SelectedIndexChanged">
                            </asp:DropDownList>
                </div>
                  <div class="col-md-3">
                    <label class="pull-left">Machine Param ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:DropDownList ID="ddlMachineParam" runat="server" CssClass="ddlselect"  AutoPostBack="True" OnSelectedIndexChanged="ddlMachineParam_SelectedIndexChanged">
                        </asp:DropDownList>
                </div>
                  <div class="col-md-3">
                    <label class="pull-left">Alias Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:TextBox ID="txtAlias" runat="server"  MaxLength="20" ReadOnly="true" onkeyup="validatespace();" disabled></asp:TextBox>
                </div>
            </div>
                    <div class="row">
                        <div class="col-md-3">
                    <label class="pull-left"></label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                        <input type="button" id="btnNewMachine" class="ItDoseButton admin" value="Add Machine" />
                </div>
                        <div class="col-md-3"></div>
                           <div class="col-md-8">
                    
                      <input type="button" id="btnAddParam" class="ItDoseButton" value="Add Param" />
                &nbsp;&nbsp;&nbsp;
                             <input type="button" id="btnModify" class="ItDoseButton" value="Modifiy Param"  /></div>
                <div class="col-md-5">
                    <input type="button" id="btnsync" class="ItDoseButton" value="Sync Parameter & Mapping" onclick="CheckMachineSync()" />
                </div>
                    </div>
               </div>
                <div id="popup" class="modal fade">
                   <div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:600px;height:330px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="popup" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add New Parameter</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">
Machine ID </label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                 <asp:TextBox ID="txtmachineid" runat="server"  MaxLength="20" ClientIDMode="Static" ReadOnly="true" CssClass="required" ></asp:TextBox>
                             </div></div>

                    <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Machine Param ID</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                <asp:TextBox ID="txtmachineparam" runat="server"  MaxLength="50" ClientIDMode="Static" CssClass="required"></asp:TextBox>
                             </div></div>

                         <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Param Alias</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                               <asp:TextBox ID="txtparam" runat="server"  MaxLength="50" ClientIDMode="Static" CssClass="required"></asp:TextBox>
                             </div></div>

                    <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Suffix</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                <asp:TextBox ID="txtsuffix" runat="server"  MaxLength="20" ClientIDMode="Static" ></asp:TextBox>
                             </div></div>
                        
                           <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Assay No</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                 <asp:TextBox ID="txtassay" runat="server"  MaxLength="20" ClientIDMode="Static" CssClass="required"></asp:TextBox>
                             </div></div>

                           <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Round Upto</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                 <asp:TextBox ID="txtround" runat="server" Text="0"  MaxLength="20" ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox>
                             </div></div>

                           <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Is Orderable</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                 <asp:CheckBox ID="chkorder" runat="server" ClientIDMode="Static" />
                             </div></div>
                          <div class="row" style="display:none">
                         <div class="col-md-6">
							   <label class="pull-left">Multiple</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                <asp:TextBox ID="txtmultiple" runat="server"  MaxLength="20" Text="0" ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox>
                             </div></div>
                      <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">Min Length</label><b class="pull-right">:</b></div>

                         <div class="col-md-18">
                                 <asp:TextBox ID="txtmin" runat="server"  MaxLength="20" Text="0"  ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox></td>
                             </div></div>
                        </div>
                        <div class="modal-footer">    
                                    <input type="button" id="btnsaveparam" class="ItDoseButton" value="Save" />
                            <button type="button"  data-dismiss="popup" >Close</button>
                             <input type="button" id="btncancel" class="ItDoseButton" value="Cancel" style="display:none" /></div>
                        </div></div>
                </div>

                    <div id="modifiedpop" class="modal fade">
<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:600px;height:330px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modifiedpop" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Modify Parma</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
                         <div class="col-md-6">
							   <label class="pull-left">
                   Machine ID</label> <b class="pull-right">:</b>                            
</div>
                         <div class="col-md-18"> <select id="ddlmachinebind" onchange="BindMachineParam();"></select>
</div></div><div class="row">
                         <div class="col-md-6"><label class="pull-left">
                   Machine Param ID</label> <b class="pull-right">:</b>                     </div>
<div class="col-md-18"><select id="ddlparam"  onchange="loaddetail();"  ></select>
</div></div><div class="row">
                         <div class="col-md-6"><label class="pull-left">
                   Param Alias</label>     <b class="pull-right">:</b>                 </div>
                         <div class="col-md-18">      <asp:TextBox ID="txtparamalias" runat="server"  MaxLength="50" ClientIDMode="Static" CssClass="required" ></asp:TextBox>
                             </div></div><div class="row">
                                  <div class="col-md-6"><label class="pull-left">
                            Suffix </label><b class="pull-right">:</b></div>
                                      <div class="col-md-18">  <asp:TextBox ID="txtsufix" runat="server"  MaxLength="20" ClientIDMode="Static" ></asp:TextBox>
                                          </div></div>
    <div class="row">   <div class="col-md-6"><label class="pull-left">
         Assay No</label><b class="pull-right">:</b></div>
        <div class="col-md-18">     <asp:TextBox ID="txtassayno" runat="server"  MaxLength="20" ClientIDMode="Static" CssClass="required"></asp:TextBox></div></div>
           <div class="row">   <div class="col-md-6"><label class="pull-left">Round Upto  </label><b class="pull-right">:</b></div>                  
               <div class="col-md-18"><asp:TextBox ID="txtroundup" runat="server" Text="0"  MaxLength="20" ClientIDMode="Static" onkeyup="return onlyNumeric(this,event)" ></asp:TextBox>
                   </div></div><div class="row">
                       <div class="col-md-6">
                           <label class="pull-left">Is Orderable</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-18">
                          <asp:CheckBox ID="chkord" runat="server" ClientIDMode="Static" />
                       </div>
                               </div>
                    <div class="row" style="display:none">
                       <div class="col-md-6">
                           <label class="pull-left">Multiple</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-18">
                       <asp:TextBox ID="TextBox7" runat="server"  MaxLength="20" Text="0"  ClientIDMode="Static"></asp:TextBox>
                       </div>
                               </div>
                              <div class="row">
                       <div class="col-md-6">
                           <label class="pull-left">Min Length</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-18">
                        <asp:TextBox ID="txtminlength" runat="server"  MaxLength="20" Text="0"  ClientIDMode="Static" onkeyup="return onlyNumeric(this,event)"></asp:TextBox>
                       </div>
                               </div>  
                                 <div class="modal-footer">
                                    <input type="button" id="btnupdate" class="ItDoseButton" value="Update" />
                                     <button type="button"  data-dismiss="modifiedpop" >Close</button>
                             <input type="button" id="Button2" class="ItDoseButton" value="Cancel" style="display:none" />
                   </div>
            </div></div></div></div>
                  <div id="divAddMachine" class="modal fade">
                      <div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:600px;height:170px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddMachine" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add Machine</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
                         <div class="col-md-5">
							   <label class="pull-left"> Machine ID</label>
                                
                         <b class="pull-right">:</b>
						  </div>
                         <div class="col-md-19">
                              <asp:TextBox ID="txtMachineName" runat="server" ClientIDMode="Static" CssClass="required" ></asp:TextBox>
                         </div></div><div class="row">
                         <div class="col-md-5"><label class="pull-left">
                            Machine Alias</label><b class="pull-right">:</b>
                            </div><div class="col-md-19">
                                 <asp:TextBox ID="txtMachineAlias" runat="server"   ClientIDMode="Static" CssClass="required"></asp:TextBox>
                            </div></div></div>
                <div class="modal-footer">
                            <input type="button" id="btnSaveMachine" class="ItDoseButton" value="Save" />
                     <button type="button"  data-dismiss="divAddMachine" >Close</button>
                             </div>
            </div></div></div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Available Mapping&nbsp;</div>
            <div>
                <table style="width:100%">
                    <tr>
                        <td></td>
                        <td> <asp:TextBox ID="txtSearch" runat="server" Width="390px" placeholder="Search Investigation" data-title="Type To Search Investigation" AutoCompleteType="Disabled"></asp:TextBox></td>
                    </tr>
                <tr style="vertical-align:top;">
                    <td style="width:190px"></td>
                <td style="width:426px">
                <asp:ListBox ID="lstPending" runat="server" Height="390px" Width="400px" SelectionMode="Multiple" onkeyup="if(event.keyCode==13){$('#btnAddMapping').click();};"></asp:ListBox>
                <%--<cc1:ListSearchExtender id="ListSearchExtender1" runat="server" TargetControlID="lstPending" PromptText="Type to search" PromptPosition="Top" />--%>
                </td>
                <td>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:Button ID="btnAddMapping" runat="server" Text=">>"  CssClass="ItDoseButton"  CommandName="Add" ToolTip="Click to Add Mapping" ClientIDMode="Static" OnClick="SaveMapping_Click" />
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:Button ID="btnDeleteMapping" runat="server" Text="<<"  CssClass="ItDoseButton" CommandName="Delete"  ToolTip="Click to Delete Mapping" ClientIDMode="Static" OnClick="SaveMapping_Click" />
                </td>
                <td>
                <asp:ListBox ID="lstMapping"  SelectionMode="Multiple" runat="server" Height="390px" Width="400px"></asp:ListBox>
                
                <cc1:ListSearchExtender id="LSE" runat="server" TargetControlID="lstMapping" PromptText="Type to search" PromptPosition="Top" />
                </td>
                
                </tr>
                </table>
                
                </div>
        </div>
    </div>
    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = lstPending.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<%=txtSearch.ClientID %>').keyup(function (e) {
                searchByInBetween("", "", document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=lstPending.ClientID%>'), document.getElementById('btnAddMapping'), values, keys, e)

            });
        });
    </script>
</asp:Content>

