<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="OTSearch.aspx.cs" Inherits="Design_OT_OTSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="sm" runat="server" />
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>

    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
        }


        function callRegistration(TID, Status, PID, LoginType, LTN, Type) {
            //alert(Status);
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            iframePatient.location.href = "../OT/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + "&Type=OPD";

        }
        function callPAC(TID, Status, PID, LoginType, LTN) {
            debugger;
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            iframePatient.location.href = "../OT/PRE/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + " ";
        }
        function callSchedule(TID, Status, PID, LoginType, LTN) {
            debugger;
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            iframePatient.location.href = "../OT/Post/OT_PostMainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + " ";
        }


        function callOtNotes(TID, Status, PID, LoginType, LTN) {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";
            iframePatient.location.href = "../OT/Schedule/OT_MainForm.aspx?TID=" + TID + "&Status=" + Status + "&PID=" + PID + "&LoginType=" + LoginType + "&LedgerTransactionNo=" + LTN + " ";
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mdlPatient')) {
                    $find('mdlPatient').hide();

                }
            }
        }

        function closePatientDetail() {
            if ($find('mdlPatient')) {
                $find('mdlPatient').hide();

            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientID" runat="server" AutoCompleteType="Disabled"
                                ToolTip="Enter Patient ID" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" ToolTip="Enter Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD&nbsp; No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIpNo" runat="server" AutoCompleteType="Disabled"
                                TabIndex="3" ToolTip="Enter IPD No."></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblfromdate" runat="server" Text="From Date"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="fromdate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="fromdate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lbltodate" runat="server" Text="To Date"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="todate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="todate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
            </div>
            <div class="col-md-1"></div>
        </div>
    </div>
    <div class="POuter_Box_Inventory textCenter">
        <asp:Button ID="btnSearch" runat="server" CssClass="save margin-top-on-btn" TabIndex="4" Text="Search" OnClick="btnSearch_Click" />&nbsp;
    </div>
    <div class="POuter_Box_Inventory" style="text-align: center;">
        <div class="Purchaseheader">
            Patient Details Found
        </div>
        <div style="overflow: auto; padding: 3px; width: 100%; height: 303px;">
            <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" OnRowCommand="grdPatient_RowCommand">
                <Columns>

                    <asp:TemplateField HeaderText="View">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("PatientID")+"#"+Eval("TransactionID")+"#"+""+"#"+Eval("Status")%>' CommandName="View" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField Visible="false" HeaderText="Registration">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbSelectReg" ToolTip="OT Registration" runat="server" ImageUrl="~/Images/Post.gif" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("Status")+"#"+Eval("PatientID")+"#"+Eval("LedgerTransactionNo")%>' CommandName="Registration" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Re-Schedule & Approve">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbSelect3" ToolTip="OT Schedule" runat="server" ImageUrl="~/Images/Post.gif" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("Status")+"#"+Eval("PatientID")+"#"+Eval("LedgerTransactionNo")%>' CommandName="OTSCHEDULE" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="P.A.C.">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbSelect2" ToolTip="Pre-Anaesthetic Check-Up" runat="server" ImageUrl="~/Images/Post.gif" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("Status")+"#"+Eval("PatientID")+"#"+Eval("LedgerTransactionNo")%>' CommandName="PAC" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Notes">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        <ItemTemplate>
                            <asp:ImageButton ID="imbSelect" ToolTip="OT Notes" runat="server" ImageUrl="~/Images/Post.gif" CausesValidation="false" CommandArgument='<%# Eval("TransactionID")+"#"+Eval("Status")+"#"+Eval("PatientID")+"#"+Eval("LedgerTransactionNo")%>' CommandName="POI" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Type">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        <ItemTemplate>

                            <label><%# Util.GetString(Eval("status")).Replace("IN","IPD")%></label>
                        </ItemTemplate>

                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="UHID">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        <ItemTemplate>
                            <label><%# Util.GetString(Eval("PatientID"))%></label>
                        </ItemTemplate>
                    </asp:TemplateField>


                    <asp:TemplateField HeaderText="IPD No.">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle"  />

                        <ItemTemplate>

                            <asp:Label ID="lblTnxId" runat="server" Visible='<%# Util.GetBoolean(Eval("Type")) %>' Text='<%# Util.GetString(Eval("TransactionID")).Replace("ISHHI","")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="PName" HeaderText="Name">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="AgeSex" HeaderText="Sex/Age">
                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Date" HeaderText="Date">
                        <ItemStyle HorizontalAlign="Left"  CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>

                    <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>

                    <asp:BoundField DataField="Address" HeaderText="Address">
                        <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>

                </Columns>
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
            </asp:GridView>
        </div>
    </div>
    <asp:Panel ID="Panel1" runat="server" BackColor="#F3F7FA" BorderStyle="None"
        Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 800px;">
            <div class="content">
                <div style="text-align: center;">
                    <div class="POuter_Box_Inventory" style="width: 780px; text-align: center;">
                        <div id="Div1" class="Purchaseheader" style="text-align: center">
                            Patient IPD Information&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                             <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePatientDetail()" />
                                 to close</span></em>
                        </div>
                        <table border="0" style="border-collapse: collapse; width: 760px">
                            <tr>
                                <td style="text-align: right; width: 80px">Patient&nbsp;Name&nbsp;:&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblPName" CssClass="ItDoseLabelSp" runat="server"></asp:Label>
                                </td>
                                <td style="text-align: right; width: 80px">Address :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblAddress" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 80px">Age :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblAge" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                                <td style="text-align: right; width: 80px">Sex :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblGender" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 80px">Case Type :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblCase" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                                <td style="text-align: right; width: 80px">Room No. :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblRoom" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 80px">Admit&nbsp;Date&nbsp;Time&nbsp;:&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblAdmitDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                                <td style="text-align: right; width: 80px">Discharge&nbsp;Date&nbsp;:&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblDisDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 80px">Contact No. :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblMobile" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                                <td style="text-align: right; width: 80px; display: none">Mobile No. :&nbsp;</td>
                                <td style="text-align: left; width: 220px; display: none">
                                    <asp:Label ID="lblPhone" Style="display: none" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            </tr>
                            <tr style="display: none">
                                <td style="text-align: right; width: 80px">KinRelation</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblKinRelation" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                                <td style="text-align: right; width: 80px">Kin Name :&nbsp;</td>
                                <td style="text-align: left; width: 220px">
                                    <asp:Label ID="lblKinName" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; width: 80px"></td>
                                <td style="text-align: left; width: 220px"></td>
                                <td style="text-align: right; width: 80px"></td>
                                <td style="text-align: left; width: 220px"></td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center">
                                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton"
                                        Text="Close" /></td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: center">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    &nbsp;&nbsp;
                </div>
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mdlPatient" BehaviorID="mdlPatient" runat="server" CancelControlID="btnClose"
        TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1"
        X="100" Y="80">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
    </div>
</asp:Content>

