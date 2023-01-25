<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Rate_scheduleCharges.aspx.cs"
    Inherits="Design_EDP_Rate_scheduleCharges" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="aspx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            document.getElementById("Pbody_box_inventory").style.display = 'none';
        }
        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });
            $('#ToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                dataType: "json",
                async: true,
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('Valid To date can not be less than Valid From date');
                        $("#SaveRateSchedule").attr('disabled', 'disabled');
                        return false;
                    }
                    else {
                        $('#lblMsg').text('');
                        $("#SaveRateSchedule").removeAttr('disabled');
                    }

                }
            });
        }
        function validate() {
            var con = 0;
            $('#lblMsg').text('');
            if ($("#ddlpanel").val() == "0") {
                $('#lblMsg').text('Please Select Panel');
                $("#ddlpanel").focus();
                con = 1;
                return false;
            }

            if ($.trim($("#rateName").val()) == "") {
                $('#lblMsg').text('Please Enter Schedule Name');
                $("#rateName").focus();
                con = 1;
                return false;
            }

            ChkDate();
            if (con == "0")
                return true;

        }

    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">

            <b>Schedule of Charges<br />
            </b>
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div style="" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Create New Schedule of Charge
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlpanel" ClientIDMode="Static" runat="server" OnSelectedIndexChanged="ddlpanel_SelectedIndexChanged"
                                AutoPostBack="True" Width="155px" ToolTip="Select Panel" TabIndex="1">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Schedule Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="rateName" runat="server" ClientIDMode="Static" Width="95%" MaxLength="20" TabIndex="2" ToolTip="Enter Schedule Name"></asp:TextBox>
                            <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set It Current
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="CBCur" runat="server" ToolTip="Check If Set It Current"></asp:CheckBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid From 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" TabIndex="3"
                                ToolTip="Click To Select Valid From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true"
                                Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Valid To Date"
                                TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="ToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">

            <asp:Button ID="SaveRateSchedule" ClientIDMode="Static" OnClick="SaveRateSchedule_Click" runat="server" TabIndex="5"
                Text="Save" CssClass="ItDoseButton" ToolTip="Click To Save" OnClientClick="return validate()"></asp:Button>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Schedule of Charges
            </div>
            <div id="SchData" style="text-align: center">
                <asp:GridView ID="grdSchedule" runat="server" Width="100%" CssClass="GridViewStyle"
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="Pname" HeaderText="Panel Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle"></HeaderStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="NAME" HeaderText="Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle"></HeaderStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="DateFrom" HeaderText="Valid From">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle"></HeaderStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="DateTo" HeaderText="Valid To">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle"></HeaderStyle>
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Current Default">
                            <ItemTemplate>
                                <asp:Label ID="lblIsDefault" runat="server" Text='<%# Util.GetString(Eval("IsDefault"))=="1" ? "Yes" :"NO" %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField Visible="False">
                            <ItemTemplate>

                                <asp:Label ID="lblPanelID" runat="server" Text='<%# Eval("PanelID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblScheduleID" runat="server" Text='<%# Eval("ScheduleChargeID") %>' Visible="False"></asp:Label>


                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Set Default">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkDefault" runat="server" ToolTip="Check If Set Default" AutoPostBack="True" Checked='<%# Util.GetBoolean(Util.GetString(Eval("IsDefault"))=="1" ? "true" :"false") %>' OnCheckedChanged="chkDefault_CheckedChanged"></asp:CheckBox>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle"></AlternatingRowStyle>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center" >
                <asp:Button ID="btnUpdate" runat="server" Text="Update"
                    CssClass="ItDoseButton" OnClick="btnUpdate_Click"
                    ToolTip="Click To Update" />

            </div>
        </div>
    </div>


</asp:Content>
