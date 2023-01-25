<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ViewPatientOrder_Sets.aspx.cs" Inherits="Design_IPD_ViewPatientOrder_Sets" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
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
                    $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    $('#<%=grdPatient.ClientID %>').hide();
                    return;
                }
            });
        }

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');

                        getDate();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }
        function Blank() {
            $("input[type=text], textarea").val("");
            $('input[type=radio]').prop('checked', false);
            $('input[type=checkbox]').prop('checked', false);
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpeConsultation')) {
                    $find('mpeConsultation').hide();
                }
                if ($find('mpeGeneral')) {
                    $find('mpeGeneral').hide();
                }
                if ($find('mpeDiet')) {
                    $find('mpeDiet').hide();
                }
                if ($find('mpeLog')) {
                    $find('mpeLog').hide();
                }
                if ($find('mpeMedicine')) {
                    $find('mpeMedicine').hide();
                }
                if ($find('mpeDiagnosis')) {
                    $find('mpeDiagnosis').hide();
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
       <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Patient Order Set Search</b>
            </div>
            <div style="text-align: center;">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />&nbsp;
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr>
                    <td style="width: 15%; text-align: right">UHID :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtPatientID" runat="server" ToolTip="Enter UHID"
                            Width="176px" TabIndex="1" MaxLength="50"></asp:TextBox>
                    </td>
                    <td style="width: 15%; text-align: right">Patient Name :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtName" runat="server"
                            TabIndex="2" ToolTip="Enter Patient Name" Width="176px" MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">IPD No. :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="txtTransactionNo" runat="server" MaxLength="10" TabIndex="3" ToolTip="Enter IPD No."
                            Width="176px"></asp:TextBox>
                       
                    </td>
                    <td style="width: 15%; text-align: right;">&nbsp;</td>
                    <td style="width: 35%; text-align: left;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 15%; text-align: right">From Date :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="176px"
                            ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 15%; text-align: right">To Date :&nbsp;
                    </td>
                    <td style="width: 35%; text-align: left">
                        <asp:TextBox ID="ucToDate" runat="server" Width="176px" ClientIDMode="Static" TabIndex="6"
                            ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="width: 15%; text-align: right">Order Type :&nbsp; </td>
                    <td style="width: 35%; text-align: left">

                        <asp:DropDownList ID="ddlOrderType" runat="server" BackColor="Yellow" >
                            <asp:ListItem >All</asp:ListItem>
                            <asp:ListItem>Medicine</asp:ListItem>
                            <asp:ListItem  Selected="True">IPD Admission</asp:ListItem>
                            <asp:ListItem>Diet</asp:ListItem>
                            <asp:ListItem>Lab & Radio</asp:ListItem>
                            <asp:ListItem>General</asp:ListItem>
                            <asp:ListItem>Consultations Order</asp:ListItem>
                        </asp:DropDownList>

                    </td>
                    <td style="width: 15%; text-align: right">&nbsp;</td>
                    <td style="width: 35%; text-align: left">&nbsp;</td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="7"
                    Text="Search" ToolTip="Click To Search" OnClick="btnSearch_Click" />
            </div>
        </div>
                <div class="POuter_Box_Inventory" style="text-align: center;" id="dvgv">
                    <div class="Purchaseheader">
                        Patient Details</div>
                    <div style="overflow: auto; padding: 3px; height: 350px;">
                        <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPatient_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="90px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRNo" Text='<%#Util.GetString(Eval("PatientID")) %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IPD&nbsp;No." Visible="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblTransactionID" Text='<%#Util.GetString(Eval("TransactionID")) %>'
                                            runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemStyle  CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPName" Text='<%# Eval("PatientName") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="AgeSex" HeaderText="Age/Sex">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="90px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EntryBy" HeaderText="Doctor">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="160px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="OrderSet" HeaderText="Order Set">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="250px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="EntryDate" HeaderText="Date">
                                    <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" Width="150px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="View Order">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgView" ToolTip="View" runat="server" ImageUrl="../../Images/view.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("EntryID")+"#"+Eval("OrderSet")%>' CommandName="Aview"/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="View Log" Visible="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgLog" ToolTip="View" runat="server" ImageUrl="~/Images/log.jpg" Width="30"
                                            CausesValidation="false" CommandArgument='<%# Eval("EntryID")+"#"+Eval("OrderSet")%>' CommandName="ALog" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </div>
                </div>
    </div>
    <%--Medicine Order Detail PopUp--%>
        <asp:Panel ID="pnlMed" Width="700" Height="200px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader" runat="server" id="Div1" style="text-align: right;">
                <asp:ImageButton runat="server" ID="imgCancelMed" ImageUrl="~/Images/Delete.gif" /><div style="display: none">
                    <asp:Button ID="btnNM" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td>
                            <asp:GridView ID="grdMedicinePopUp" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                                <Columns>
                                    <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Medicine Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMedicine" runat="server" Text='<%#Eval("MedicineName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Dose" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDose" runat="server" Text=' <%#Eval("Dose")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Times" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTimes" runat="server" Text=' <%#Eval("Timing") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Duration" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDays" runat="server" Text=' <%#Eval("Duration") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Remark" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRemarks" runat="server" Text=' <%#Eval("Remark")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeMedicine" runat="server" CancelControlID="imgCancelMed" ClientIDMode="Static"
            DropShadow="true" TargetControlID="btnNM" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlMed" PopupDragHandleControlID="dragHandle" />

        <%--Diagnosis ORDER Detail PopUp--%>
        <asp:Panel ID="pnlDiagnosis" Width="700" Height="200px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader" runat="server" id="Div4" style="text-align: right;"><em><span style="font-size: 7.5pt">Press esc or click
                <asp:ImageButton runat="server" ID="ImageButton2" ImageUrl="~/Images/Delete.gif" />to close</span></em><div style="display: none">
                    <asp:Button ID="Button3" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td>
                            <asp:GridView ID="grdDiagnosisPopUp" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                                <Columns>
                                    <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Investigation Name" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRemark" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                     <asp:TemplateField HeaderText="Remarks" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRemark" runat="server" Text='<%#Eval("Remark") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeDiagnosis" runat="server" CancelControlID="ImageButton2" ClientIDMode="Static"
            DropShadow="true" TargetControlID="Button3" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlDiagnosis" PopupDragHandleControlID="dragHandle" />

        <%--General Order Detail PopUp--%>
        <asp:Panel ID="pnlGeneral" Width="700" Height="200px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader" runat="server" id="Div3" style="text-align: right;"><em><span style="font-size: 7.5pt">Press esc or click
                <asp:ImageButton runat="server" ID="ImageButton1" ImageUrl="~/Images/Delete.gif" />to close</span></em><div style="display: none">
                    <asp:Button ID="Button2" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td>
                            <asp:GridView ID="grdGeneralPopUp" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                                <Columns>
                                    <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Order Detail" HeaderStyle-Width="650px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblGeneralOrder" runat="server" Text='<%#Eval("OrderDetail") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeGeneral" runat="server" CancelControlID="ImageButton1" ClientIDMode="Static"
            DropShadow="true" TargetControlID="Button2" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlGeneral" PopupDragHandleControlID="dragHandle" />
    <%--Cosultation ORDER Detail PopUp--%>
        <asp:Panel ID="PnlConsultation" Width="700" Height="200px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader" runat="server" id="Div6" style="text-align: right;"> <em><span style="font-size: 7.5pt">Press esc or click
                <asp:ImageButton runat="server" ID="ImageButton5" ImageUrl="~/Images/Delete.gif" />  to close</span></em><div style="display: none">
                    <asp:Button ID="Button6" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td>
                            <asp:GridView ID="grdconsultationDetail" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                                <Columns>
                                    <asp:TemplateField HeaderText="Doctor Name" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("Doctor_name") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Type" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblType" runat="server" Text='<%#Eval("TYPE") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Consultation Date" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                              <asp:Label ID="lblDate" runat="server" Text='<%#Eval("SpecialistDate") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Consultation Time" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                              <asp:Label ID="lblTime" runat="server" Text='<%#Eval("SpecialistTime") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeConsultation" runat="server" CancelControlID="ImageButton3" ClientIDMode="Static"
            DropShadow="true" TargetControlID="Button4" BackgroundCssClass="filterPupupBackground"
            PopupControlID="PnlConsultation" PopupDragHandleControlID="dragHandle" />

        <%--Physio Order Detail PopUp--%>
        <asp:Panel ID="pnlPhysio" Width="850" Height="500px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader" runat="server" id="Div5" style="text-align: right;"><em><span style="font-size: 7.5pt">Press esc or click
                <asp:ImageButton runat="server" ID="ImageButton3" ImageUrl="~/Images/Delete.gif" />to close</span></em><div style="display: none">
                    <asp:Button ID="Button4" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td>Order Set Type:
                            <asp:Label ID="lblOrderSetType" runat="server" Font-Bold="true" ForeColor="Blue"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Side :<asp:Label ID="lblSide" runat="server" Font-Bold="true" ForeColor="Blue"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Repeater ID="repRehapOrderSet" ClientIDMode="Static" runat="server" OnItemDataBound="repRehapOrderSet_ItemDataBound">
                                <HeaderTemplate>
                                    <table id="tbRehab" border="1" width="100%" style="width: 600px; font-size: 12px;">
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr id="trHeading" runat="server">
                                        <td colspan="2" align="center" style="width: 18%; background-color: Gray">
                                            <asp:Label ID="lblHead" runat="server" Text='<%#Eval("SubHeading") %>'></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="width: 18%;">
                                            <asp:CheckBox ID="chkRehab" Visible='<%#Util.GetBoolean(Eval("DispalyCheckBox"))%>'
                                                runat="server" Checked='<%#Util.GetBoolean(Eval("ItemCheck"))%>'></asp:CheckBox>
                                            <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                            <asp:Label ID="lblItemID" runat="server" Visible="false" Text='<%#Eval("ItemID") %>'></asp:Label>
                                        </td>
                                        <td align="left" style="width: 12%;">
                                            <%--<asp:TextBox ID="txtValue" Width="200px" Visible='<%#Util.GetBoolean(Eval("DisplayTextBox"))%>'
                                                runat="server" MaxLength="200" Text='<%#Eval("textvalue") %>'></asp:TextBox>--%>
                                            <asp:Label ID="lblValue" Visible='<%#Util.GetBoolean(Eval("DisplayTextBox"))%>'
                                                runat="server" Font-Bold="true" Text='<%#Eval("textvalue") %>'></asp:Label>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody> </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpePhysio" runat="server" CancelControlID="ImageButton3"
            DropShadow="true" TargetControlID="Button4" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlPhysio" PopupDragHandleControlID="dragHandle" />

        <%--Diet Order Detail PopUp--%>
        <asp:Panel ID="pnlDiet" Width="700" Height="200px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader"style="text-align: right;"><em><span style="font-size: 7.5pt">Press esc or click
                <asp:ImageButton runat="server" ID="ImageButton4" ImageUrl="~/Images/Delete.gif" />to close</span></em><div style="display: none">
                    <asp:Button ID="Button5" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td class="auto-style2">
                            <asp:CheckBox ID="chkFullDiet" runat="server" Text="Full Diet" />
                        </td>
                        <td style="text-align: left">
                            <asp:CheckBox ID="chkFeedingTube" runat="server" Text="Feeding Tube" />
                        </td>
                        <td style="text-align: left">&nbsp;</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="auto-style2">
                            <asp:CheckBox ID="chkTPN" runat="server" Text="TPN" />
                        </td>
                        <td style="text-align: left">
                            <asp:CheckBox ID="chkOralFluids" runat="server" Text="Oral Fluids" />
                        </td>
                        <td style="text-align: left">&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="auto-style2">
                            <asp:CheckBox ID="chkNil" runat="server" Text="Nil By Mouth" />
                            <asp:TextBox ID="txtMouth" runat="server" Width="50px"></asp:TextBox>
                            /24 then
                    <asp:TextBox ID="txtThen" runat="server"></asp:TextBox>
                        </td>
                        <td>&nbsp;</td>
                        <td style="text-align: left">&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="style1" colspan="2">Comment :
                    <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Width="341px"></asp:TextBox>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeDiet" runat="server" CancelControlID="ImageButton4" ClientIDMode="Static"
            DropShadow="true" TargetControlID="Button5" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlDiet" PopupDragHandleControlID="dragHandle" />

    <%--Log PopUp--%>
        <asp:Panel ID="pnlLog" Width="700" Height="350px" runat="server" CssClass="pnlRequestItemsFilter" ScrollBars="Auto" Style="display: none;">
            <div class="Purchaseheader" runat="server" id="Div2" style="text-align: right;"><em><span style="font-size: 7.5pt">Press esc or click
                <asp:ImageButton runat="server" ID="imgCancelLog" ImageUrl="~/Images/Delete.gif" />to close</span></em><div style="display: none">
                    <asp:Button ID="Button1" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
            </div>
            <div>
                <table width="100%">
                    <tr>
                        <td>
                            <asp:GridView ID="grdLog" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                                <Columns>
                                    <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Viewed By" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMedicine" runat="server" Text='<%#Eval("ReadBy") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Viewed Date" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDose" runat="server" Text=' <%#Eval("ReadDate")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeLog" runat="server" CancelControlID="imgCancelLog" ClientIDMode="Static"
            DropShadow="true" TargetControlID="Button1" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlLog" PopupDragHandleControlID="dragHandle" />
</asp:Content>

