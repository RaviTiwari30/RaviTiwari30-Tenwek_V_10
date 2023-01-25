<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="MachineReading.aspx.cs" Inherits="Design_Machine_MachineReading" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script type="text/javascript">
        function fancypopup(href) {
            $.fancybox({
                maxWidth: 1350,
                maxHeight: 1350,
                fitToView: false,
                width: '100%',
                href: href,
                height: '100%',
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
        function getMachineParamMapping(MachineID, MachineParamID) {
            //var w = 950;
            //var h = 650;
            //var left = (screen.width / 2) - (w / 2);
            //var top = (screen.height / 2) - (h / 2);
            //popup = window.open("MachineParam.aspx?MachineID=" + MachineID + "&MachineParamID=" + MachineParamID, "view", "width=" + w + ",height=" + h + ",top=" + top + ",left=" + left + "  ");
            //popup.focus();
            //return false
            var href = "MachineParam.aspx?MachineID=" + MachineID + "&MachineParamID=" + MachineParamID;
            fancypopup(href);
        }
        function getMachineParam(MachineID, MachineParamID) {
            Clear();
            var machineId = MachineID;
            if (machineId != 0) {
                $('#popup').showModel();
                $("#txtmachineid").val(machineId);
                $("#txtmachineparam").val(MachineParamID);
                $("#chkorder").attr("checked")
            }
            else {
                modelAlert("Please Select Machine Name");
            }
        }
        $(document).ready(function () {
            $("#btnsaveparam").click(function () {

                var MachineParam = $("#txtmachineparam").val();
                var Machine = $("#txtmachineid").val();
                var ParamAlias = $("#txtparam").val();
                var Suffix = $("#txtsuffix").val();
                var AssayNo = $("#txtassay").val();
                var RoundUpto = $("#txtround").val();
                var IsOrderable = $("#chkorder").attr("checked") ? 1 : 0;
                var MinLength = $("#txtmin").val();
                if (ValidationParamSave(Machine, MachineParam, AssayNo, RoundUpto, IsOrderable, MinLength) == true) {
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
                                window.location.reload(1);
                            }
                            else {
                                modelAlert(obj);
                            }
                        }
                    });
                }
                else { modelAlert("Please enter the Mandatory Field"); }
            });
            $('#dtFrom').change(function () {
                ChkDate();

            });

            $('#dtTo').change(function () {
                ChkDate();

            });

        });

        function getDate() {

            $.ajax({

                url: "../common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#<%=btnSearch.ClientID%>').attr('disabled', 'disabled');
                    $('#<%=btnReport.ClientID%>').attr('disabled', 'disabled');
                    return;
                }
            });
        }

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#dtFrom').val() + '",DateTo:"' + $('#dtTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        modelAlert( "To date can not be less than from date!");
                        getDate();
                    }
                    else {
                        $('#<%=lblMsg.ClientID%>').text('');
                        $('#<%=btnSearch.ClientID%>').removeAttr('disabled');
                        $('#<%=btnReport.ClientID%>').removeAttr('disabled');
                    }
                }
            });

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
        function Clear() {
            $("#txtmachineparam").val('');
            $("#txtmachineid").val('');
            $("#txtparam").val('');
            $("#txtsuffix").val('');
            $("#txtassay").val('');
            $("#txtround").val('0');
            $("#chkorder").attr("checked",false);
            $("#txtmin").val('0');
            
        }
        function ValidationParamSave(Machine, MachineParam, AssayNo, RoundUpto, IsOrderable, MinLength) {
            if (Machine == "")
            {
                $.alertable.alert("","Machine Name Can Not Be blank");
                return false;
            }
            else if (MachineParam == "") {
                $.alertable.alert("","Machine Param ID Can Not Be blank");
                return false;
            }
            else if (AssayNo == "") {
                modelAlert("Assay No. Can Not Be blank");
                return false;
            }
            else if (RoundUpto == "") {
                modelAlert("Round Up to Can Not Be blank");
                return false;
            }
            else if (IsOrderable == "") {
                modelAlert("IsOrderable to Can Not Be blank");
                return false;
            }
            else if (MinLength == "") {
                modelAlert("MinLength to Can Not Be blank");
                return false;
            }
            return true;
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Machine Data</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
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
                        <asp:DropDownList ID="ddlMachine" runat="server" ></asp:DropDownList>
                </div>
                 <div class="col-md-3">
                    <label class="pull-left">Barcode No</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:TextBox ID="txtSampleID" runat="server"/>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Show Only</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="ddlType" runat="server" >
                                <asp:ListItem>--Select--</asp:ListItem>
                                <asp:ListItem Value="1">Synced Data</asp:ListItem>
                                <asp:ListItem Value="0">Pending Data</asp:ListItem>
                            </asp:DropDownList>
                </div>
               </div>
                    <div class="row">
                        <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                          <asp:TextBox ID="dtFrom" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText" 
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="dtFrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                </div>
                          <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="dtTo" runat="server" ClientIDMode="Static"  CssClass="ItDoseTextinputText"
                                TabIndex="1"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="dtTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                </div>
                            <div class="col-md-3">
                    <label class="pull-left">Page Size</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                 <asp:DropDownList ID="ddlPageSize" runat="server">
                                <asp:ListItem Value="20">20</asp:ListItem>
                                <asp:ListItem Value="40">40</asp:ListItem>
                                <asp:ListItem Value="60">60</asp:ListItem>
                                <asp:ListItem Value="80">80</asp:ListItem>
                                <asp:ListItem Value="100" Selected="True">100</asp:ListItem>
                                <asp:ListItem Value="All">All</asp:ListItem>
                            </asp:DropDownList>
                </div>
                    </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="row">
                <div style="text-align: center" class="col-md-4">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color:lightpink"  class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Not Synced</b>
                </div>
                <div style="text-align: center" class="col-md-4">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color:lightgreen"  class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Synced</b>
                </div>
                <div class="col-md-8" style="text-align:center">
                    <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                    OnClick="btnSearch_Click" />
                </div>
                <div class="col-md-8    ">
                    <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" Visible="false" />
                </div>
            </div>
            </div>
              <div class="POuter_Box_Inventory">
                  
                    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div>
                <asp:GridView ID="grdSearch" runat="server" AllowSorting="True" AutoGenerateColumns="False" Width="100%"
                    CssClass="GridViewStyle" EnableModelValidation="True" OnRowDataBound="grdSearch_RowDataBound"
                    OnPageIndexChanging="grdSearch_PageIndexChanging">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" Height="18px" VerticalAlign="Middle" HorizontalAlign="Center"  />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sample ID">
                            <ItemTemplate>
                                <%#Eval("LabNo") %>
                                <asp:Label ID="lblSync" runat="server" Text='<%#Eval("synccheck") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Machine Param ID">
                            <ItemTemplate>
                                <asp:Label ID="lblMachine_ParamID" runat="server" Text='<%#Eval("Machine_ParamID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Param Alias">
                            <ItemTemplate>
                                <asp:Label ID="lblAlias" runat="server" Text='<%#Eval("machine_param") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Machine">
                            <ItemTemplate>
                                <asp:Label ID="lblMACHINE_ID" runat="server" Text='<%#Eval("MACHINE_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reading">
                            <ItemTemplate>
                                <asp:Label ID="lblReading" runat="server" Text='<%#Eval("Reading") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center"  />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("dtEntry") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                               <asp:TemplateField HeaderText="Add Param">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick="getMachineParam('<%#Eval("MACHINE_ID") %>','<%#Eval("Machine_ParamID") %>');" 
                                title="Click for Test Mapping" ><img alt="" src="../../Images/ButtonAdd.png" style='<%# Util.GetString(Eval("isSync"))%>' /></a>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Check Mapping">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick="getMachineParamMapping('<%#Eval("MACHINE_ID") %>','<%#Eval("Machine_ParamID") %>');" 
                                title="Click for Test Mapping" ><img alt="" src="../../Images/setting.png" width="20px" height="20px" /></a>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" VerticalAlign="Middle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                    </Columns>
                    <PagerSettings FirstPageText="First Page" LastPageText="Last Page" Position="TopAndBottom"
                        Mode="NumericFirstLast" />
                </asp:GridView>
            </div>
        </div>
    </div>
      <div id="popup" class="modal fade">
                   <div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:400px;height:330px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="popup" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add New Parameter</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">
Machine ID: </label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                 <asp:TextBox ID="txtmachineid" runat="server"  MaxLength="20" ClientIDMode="Static" ReadOnly="true" CssClass="required" ></asp:TextBox>
                             </div></div>

                    <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Machine Param ID</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                <asp:TextBox ID="txtmachineparam" runat="server"  MaxLength="20" ClientIDMode="Static" CssClass="required"></asp:TextBox>
                             </div></div>

                         <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Param Alias</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                               <asp:TextBox ID="txtparam" runat="server"  MaxLength="20" ClientIDMode="Static" CssClass="required"></asp:TextBox>
                             </div></div>

                    <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Suffix</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                <asp:TextBox ID="txtsuffix" runat="server"  MaxLength="20" ClientIDMode="Static" ></asp:TextBox>
                             </div></div>
                        
                           <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Assay No</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                 <asp:TextBox ID="txtassay" runat="server"  MaxLength="20" ClientIDMode="Static" CssClass="required"></asp:TextBox>
                             </div></div>

                           <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Round Upto</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                 <asp:TextBox ID="txtround" runat="server" Text="0"  MaxLength="20" ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox>
                             </div></div>

                           <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Is Orderable</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                 <asp:CheckBox ID="chkorder" runat="server" ClientIDMode="Static" />
                             </div></div>
                          <div class="row" style="display:none">
                         <div class="col-md-10">
							   <label class="pull-left">Multiple</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                <asp:TextBox ID="txtmultiple" runat="server"  MaxLength="20" Text="0" ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox>
                             </div></div>
                      <div class="row">
                         <div class="col-md-10">
							   <label class="pull-left">Min Length</label><b class="pull-right">:</b></div>

                         <div class="col-md-14">
                                 <asp:TextBox ID="txtmin" runat="server"  MaxLength="20" Text="0"  ClientIDMode="Static" onkeypress="return checkNumeric(event,this);"></asp:TextBox></td>
                             </div></div>
                        </div>
                        <div class="modal-footer">    
                                    <input type="button" id="btnsaveparam" class="ItDoseButton" value="Save" />
                            <button type="button"  data-dismiss="popup" >Close</button>
                             <input type="button" id="btncancel" class="ItDoseButton" value="Cancel" style="display:none" /></div>
                        </div></div>
                </div>
</asp:Content>
