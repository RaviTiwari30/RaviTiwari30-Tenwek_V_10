<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DischargeDisplayScreenNew.aspx.cs" Inherits="Design_IPD_DischargeDisplayScreenNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery.blockUI.js" type="text/javascript"></script>

    <script type="text/javascript">
        function BlockUI(elementID) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $("#" + elementID).block({
                    message: '<table align = "center"><tr><td>' +
     '<img src="../../Images/loadingAnim.gif"/></td></tr></table>',
                    css: {},
                    overlayCSS: {
                        backgroundColor: '#000000', opacity: 0.6
                    }
                });
            });
            prm.add_endRequest(function () {
                $("#" + elementID).unblock();
            });
        }
        $(document).ready(function () {
            BlockUI("div1");
            $.blockUI.defaults.css = {};
        });

        var OpenDivSearchModel = function (e) {
            e.preventDefault();
            var divSearchbyDate = $('#divSearchbyDate');
            divSearchbyDate.showModel();
        }
        var CloseDivSearchModel = function () {
            $('#divSearchbyDate').closeModel();
        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="row">
            <div class="col-md-24">
                <div class="row">
                    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                    <asp:Timer ID="Timer1" runat="server" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>
                    <div style="text-align: center;">
                        <div class="row">
                            <div class="col-md-21">
                                <strong><span style="font-size: 25pt; text-align:center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Discharge Tracker :</span></strong>
                            </div>
                            <div class="col-md-3">
                                <asp:Button ID="btnExport" Text="Export" runat="server" OnClientClick="OpenDivSearchModel(event);" />
                            </div>
                        </div>
                        <hr size="5" style="background-color: #2C5A8B;" />
                        <label style="text-align: left; width: 100%">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Discharge Delay</b>
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: red;" class="circle blink"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Status Done</b>
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #ffa500a6;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Not Reached</b>
                        </label>
                    </div>
                    <asp:UpdatePanel runat="server" ID="update_Pnl">
                        <ContentTemplate>
                            <div runat="server" id="div1">
                                <asp:GridView Width="100%" ID="grdDischargeScreen" runat="server"  AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdDischargeScreen_RowDataBound" ShowFooter="True">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="IPD No." HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIPNo" runat="server" Text='<%# Eval("TransNo") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="50px" Font-Size="Smaller" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="50px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="P.Name" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPName" runat="server" Text='<%# Eval("PName") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="150px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="150px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Doctor" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDoctorName" runat="server" Text='<%# Eval("DoctorName") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="100px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="100px" />
                                        </asp:TemplateField>
                                       <%-- <asp:TemplateField HeaderText="Panel" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPanel" runat="server" Text='<%# Eval("Panel") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="90px" Font-Size="Smaller" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="90px" />
                                        </asp:TemplateField>--%>
                                        <asp:TemplateField HeaderText="Bed No." HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="BedNo" runat="server" Text='<%# Eval("BedNo") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="150px" HorizontalAlign="Center" Font-Bold="True" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" HorizontalAlign="Center" Font-Bold="True" />
                                        </asp:TemplateField>
                                       <%-- <asp:TemplateField HeaderText="Discharge By" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDischargeBy" runat="server" Text='<%# Eval("DischargedBy") %>' />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" HorizontalAlign="Center" Font-Bold="True" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" HorizontalAlign="Center" Font-Bold="True" />
                                        </asp:TemplateField>--%>
                                        <asp:TemplateField HeaderText="Discharge<br/>Intimation" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDisInt" runat="server" Text='<%# Eval("Intemation") %>' /><br />
                                                <asp:Image ID="imgIntemationGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgIntemationYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pharmacy<br/>Clearance" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMedClen" runat="server" Text='<%# Eval("MedClearnace") %>' /><br />
                                                <asp:Image ID="imgMedClearnaceGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgMedClearnaceYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgMedClearnaceRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("MedClearedTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Bill In<br/>Process" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBillInProcess" runat="server" Text='<%# Eval("BillFreeze") %>' /><br />
                                                <asp:Image ID="imgBillInProcessGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgBillInProcessYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgBillInProcessRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("BillFreezedTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="90px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="90px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Bill<br/>Freezed" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBillFreeze" runat="server" Text='<%# Eval("BillFreeze") %>' /><br />
                                                <asp:Image ID="imgBillFreezeGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgBillFreezeYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgBillFreezeRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("BillFreezedTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="90px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="90px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Discharged" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDis" runat="server" Text='<%# Eval("DischargeDate") %>' /><br />
                                                <asp:Image ID="imgDischargeGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgDischargeYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgDischargeRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("DischargeTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Bill<br/>Generated" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBillGen" runat="server" Text='<%# Eval("BillDate") %>' /><br />
                                                <asp:Image ID="imgBillGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgBillYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgBillRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("BillGenTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Patient<br/>Clearance" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPatClen" runat="server" Text='<%# Eval("PatientClearnace") %>' /><br />
                                                <asp:Image ID="imgPatientClearnaceGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgPatientClearnaceYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgPatientClearnaceRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("PatClearanceTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Nurse<br/>Clearance" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblNurseClearnace" runat="server" Text='<%# Eval("NurseClearnace") %>' /><br />
                                                <asp:Image ID="imgNurseClearnaceGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgNurseClearnaceYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgNurseClearnaceRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("NurseTAT")) %>' Width="30px" Height="30px" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Room<br/>Clearance" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRoomClean" runat="server" Text='<%# Eval("RoomClearnace") %>' /><br />
                                                <asp:Image ID="imgRoomClearnaceGreen" runat="server" ImageUrl="~/Images/Greenstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgRoomClearnaceYellow" runat="server" ImageUrl="~/Images/Yellowstatus.png" Width="30px" Height="30px" />
                                                <asp:Image ID="imgRoomClearnaceRed" runat="server" ImageUrl="~/Images/Redstatus.png" CssClass="blink" Visible='<%# Util.GetBoolean(Eval("RoomTAT")) %>' Width="30px" Height="30px" DataFormatString="{0:d}" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Discharge (TAT)" HeaderStyle-Font-Size="Small">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTAT" runat="server" ForeColor="Red" Font-Bold="true" CssClass="blink" Text='<%# Eval("TAT") %>' /><br />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" Font-Size="Smaller"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Bold="True" Width="60px" />
                                        </asp:TemplateField>

                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>

                                                <asp:Label ID="lblMedClearedTAT" runat="server" Text='<%# Eval("MedClearedTAT") %>'></asp:Label>/asp:Label>
                                        <asp:Label ID="lblBillFreezedTAT" runat="server" Text='<%# Eval("BillFreezedTAT") %>'></asp:Label>/asp:Label>
                                    <asp:Label ID="lblDischargeTAT" runat="server" Text='<%# Eval("DischargeTAT") %>'></asp:Label>/asp:Label>
                                        <asp:Label ID="lblBillGenTAT" runat="server" Text='<%# Eval("BillGenTAT") %>'></asp:Label>/asp:Label>
                                        <asp:Label ID="lblPatClearanceTAT" runat="server" Text='<%# Eval("PatClearanceTAT") %>'></asp:Label>/asp:Label>
                                        <asp:Label ID="lblNurseTAT" runat="server" Text='<%# Eval("NurseTAT") %>'></asp:Label>/asp:Label>
                                        <asp:Label ID="lblRoomTAT" runat="server" Text='<%# Eval("RoomTAT") %>'></asp:Label>/asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Font-Size="15px" Font-Bold="True" Width="90px" Height="60px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Font-Size="15px" Font-Bold="True" Width="90px" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="grdDischargeScreen" />
                            <asp:AsyncPostBackTrigger ControlID="Timer1" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <style type="text/css">
        .blink {
            animation: blinker-two 1.6s linear infinite;
        }

        @keyframes blinker-two {
            100% {
                opacity: 0;
            }
        }
    </style>
    <div id="divSearchbyDate" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 200px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSearchbyDate" area-hidden="true">&times;</button>
                    <b class="modal-title">Search By Discharge Date</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left">From Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">To Date</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-8">
                                    <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Click To Select To Date"></asp:TextBox>
                                    <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnExporttoExcel" Text="Expot to Excel" runat="server" OnClick="btnExporttoExcel_Click" />
                    <button type="button" data-dismiss="divSearchbyDate">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

