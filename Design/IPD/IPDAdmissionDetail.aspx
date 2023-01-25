<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDAdmissionDetail.aspx.cs" Inherits="Design_IPD_IPDAdmissionDetail" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        function search() {
            if (($.trim($("#txtPatientId").val()) == "") && ($.trim($("#txtCRNo").val()) == "") && ($.trim($("#txtPName").val()) == "")) {
                $("#lblMsg").text('Please Enter Any One Search Criteria');
                $("#txtPatientId").focus();
               return false;
            }
        }
        function validate() {
            if ($("#<%=txtCancelReason.ClientID %>").val() == "") {
                $("#<%=lblmsgpopup.ClientID %>").text('Please Enter Cancel Reason');
                $("#<%=txtCancelReason.ClientID %>").focus();
                return false;
            }
         //   document.getElementById('<%=btnCancel.ClientID%>').disabled = true;            
        }

        function hideGrid() {
            $("#grdPatientDetail tr").remove();
            $("#<%=btnCancel.ClientID %>,.hide").hide();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpDetail")) {
                    $find("mpDetail").hide();

                }
            }

        }
        function closeDetail() {
            if ($find("mpDetail")) {
                $find("mpDetail").hide();
                $("#<%=txtCancelReason.ClientID %>").val('');
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>IPD Admission Discharge Cancel</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria  &nbsp;
            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        UHID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPatientId" runat="server" ToolTip="Enter UHID" TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        IPD No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCRNo" runat="server" ToolTip="Enter Patient IPD No." TabIndex="2" ClientIDMode="Static" MaxLength="10"></asp:TextBox>
                   
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPName" runat="server" ToolTip="Enter Patient Name" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div> 
          
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                CssClass="ItDoseButton" ToolTip="Click to Search" OnClientClick="return search()" />
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false" Style="text-align: center">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Result Details &nbsp;
                </div>
                <asp:GridView ID="grdPatientDetail" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="grdPatientDetail_SelectedIndexChanged"
                    CssClass="GridViewStyle" ClientIDMode="Static" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID" Visible="false" Text='<%#Util.GetString(Eval("TransactionID")) %>'
                                    runat="server"></asp:Label>
                                <asp:Label ID="Label2" Text='<%#Util.GetString(Eval("TransNo")) %>'
                                    runat="server"></asp:Label>
                                <asp:Label ID="lblStatus" Visible="false" Text='<%#Eval("Status") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblIsDischargeIntimate" Visible="false" Text='<%#Eval("IsDischargeIntimate") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblIsBillFreezed" Visible="false" Text='<%#Eval("IsBillFreezed") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblIsClearance" Visible="false" Text='<%#Eval("IsClearance") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblIsNurseClean" Visible="false" Text='<%#Eval("IsNurseClean") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblIsRoomClean" Visible="false" Text='<%#Eval("IsRoomClean") %>' runat="server"></asp:Label>
                                 <asp:Label ID="lblIsMedCleared" Visible="false" Text='<%#Eval("IsMedCleared") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblPatientIPDProfile_ID" Visible="false" Text='<%#Eval("PatientIPDProfile_ID") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblIsBilledClosed" Visible="false" Text='<%#Eval("IsBilledClosed") %>' runat="server"></asp:Label>
                                <asp:Label ID="lblBillNo" Visible="false" Text='<%#Eval("BillNo") %>' runat="server"></asp:Label>
                               <asp:Label ID="lblPanelInvoiceNo" Visible="false" Text='<%#Eval("panelInvoiceNo") %>' runat="server"></asp:Label> 
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PatientID" HeaderText="UHID">
                            <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                          <asp:TemplateField HeaderText="UHID" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblPatientID" Text='<%#Util.GetString(Eval("PatientID")) %>'
                                    runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PName" HeaderText="Patient Name">
                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Address" HeaderText="Address">
                            <ItemStyle CssClass="GridViewItemStyle" Width="260px" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="CaseType" HeaderText="Ward">
                            <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Room_No" HeaderText="Room No.">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Room ID" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblRoomID" Text='<%#Util.GetString(Eval("RoomId")) %>'
                                    runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField HeaderText="Select" ButtonType="Image" ShowSelectButton="true"
                            SelectImageUrl="~/Images/Post.gif">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </asp:Panel>

    </div>
    <cc1:ModalPopupExtender ID="mpDetail" runat="server" CancelControlID="btnClose"
        TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDetail"
        X="160" Y="120" BehaviorID="mpDetail">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none; width: 947px">
        <div class="Purchaseheader">

            Cancel
            <em><span style="font-size: 7.5pt;float:right" class="shat">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" alt="" onclick="closeDetail()" />
                to close</span></em>
 
        </div>

        <asp:Label ID="lblRoomID" runat="server" Visible="false"></asp:Label>
        <asp:Label ID="lblPatientIPDProfileID" runat="server" Visible="false"></asp:Label>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td style="width: 20%;" valign="middle" class="ItDoseLabel">&nbsp;</td>
                <td align="left" style="width: 20%" valign="middle">
                    <asp:RadioButton ID="rdbRoomClearance" runat="server" AutoPostBack="false" Font-Names="Verdana"
                        Font-Size="Small" GroupName="a"
                        Text="Room Clearance" Width="173px" /></td>
                <td align="left" style="width: 20%;" valign="middle">
                    <asp:RadioButton ID="rdbNursingClearance" runat="server" AutoPostBack="false" Font-Names="Verdana"
                        Font-Size="Small" GroupName="a"
                        Text="Nursing Clearance" /></td>
                <td align="right" style="width: 20%; text-align: left;"
                    valign="middle">&nbsp;<asp:RadioButton ID="rdbPatientClearance" runat="server" AutoPostBack="false" Font-Names="Verdana"
                        Font-Size="Small" GroupName="a"
                        Text="Patient Clearance" />
                </td>
                <td style="width: 20%;">
                    <asp:RadioButton ID="rdbDischarge" runat="server" GroupName="a"
                        Text="Discharged" />
                    </td>
            </tr>
            <tr>
                <td style="width: 20%;" valign="middle" class="ItDoseLabel">&nbsp;</td>
                <td align="left" style="width: 20%;" valign="middle">&nbsp;<asp:RadioButton ID="rdbBillFreezed" runat="server" AutoPostBack="false"
                    Font-Names="Verdana" Font-Size="Small" GroupName="a"
                    Text="Bill Freezed" />
                </td>
                <td style="width: 20%;">
                    <asp:RadioButton ID="rdbMedClearance" runat="server" GroupName="a"
                        Text="Revert Med Clearance" />
                </td>
                <td style="width: 20%;">
                    <asp:RadioButton ID="rdbDischargeIntimation" runat="server" GroupName="a"
                        Text="Discharge Intimation" />
                </td>
                <td align="left" style="width: 20%;">
                    <asp:RadioButton ID="rdbAdmitted" runat="server" Checked="True"
                        GroupName="a" Text="Admission" />
                </td>

            </tr>
        </table>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td style="text-align: center" colspan="4">
                    <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; width: 20%">IPD No. :&nbsp;
                </td>
                <td style="text-align: left; width: 30%">
                    <asp:Label ID="lblIPDNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    <asp:Label ID="lblPatientID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                </td>
                <td style="text-align: right; width: 20%">Status :&nbsp;
                </td>
                <td style="text-align: left; width: 30%">
                    <asp:Label ID="lblStatus" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="vertical-align: top; text-align: right; width: 20%">Cancel Reason :&nbsp;
                </td>
                <td style="vertical-align: top; text-align: left; width: 80%" colspan="3">
                    <asp:TextBox ID="txtCancelReason" ToolTip="Enter Cancel Reason" runat="server" TextMode="MultiLine" Width="280px"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>


                </td>
            </tr>

        </table>

        <div class="filterOpDiv">
            <asp:Button ID="btnCancel" runat="server" Text="Save" CssClass="ItDoseButton"
                ToolTip="Click to Cancel" OnClick="btnCancel_Click" OnClientClick="return validate();" />
            &nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnClose" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" ToolTip="Click to Cancel" />&nbsp;
        </div>
    </asp:Panel>
</asp:Content>
