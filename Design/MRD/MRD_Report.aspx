<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MRD_Report.aspx.cs" MasterPageFile="~/DefaultHome.master"
    Inherits="Design_MRD_MRD_Report" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(function () {
            $('#ucDateFrom').change(function () {
                ChkDate();

            });

            $('#ucDateTo').change(function () {
                ChkDate();

            });

        });

        

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDateFrom').val() + '",DateTo:"' + $('#ucDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnissue.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=btnexcel.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grddetail.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnissue.ClientID %>').removeAttr('disabled');
                        $('#<%=btnexcel.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

               if (status == true) {
                   $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
               }
               else {
                   $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
               }
           }
           function chkCentreCon() {
               if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
 
    </script>
    <script type="text/javascript">
//        function loadDescConsultation(str) {
//            //txtDesc
//            document.getElementById('<%=txtDesc.ClientID %>').value = str;
//            document.getElementById('<%=btnDesc.ClientID %>').click();
//        }

//        function loadDescSpecaility(str) {
//            //txtDesc
//            document.getElementById('<%=txtDescSpeciality.ClientID %>').value = str;
//            document.getElementById('<%=btnDescSpeciality.ClientID %>').click();
//        }

//        function loadDescInvestigation(str) {
//            //txtDesc
//            document.getElementById('<%=txtDescInvest.ClientID %>').value = str;
//            document.getElementById('<%=btnDescInvest.ClientID %>').click();
//        }

//        function loadDescSpecailitydtl(str) {
//            //txtDesc
//            document.getElementById('<%=txtDescSpecialitydtl.ClientID %>').value = str;
//            document.getElementById('<%=btnDescSpecialitydtl.ClientID %>').click();
//        }

//        function loadDescConsultationDoc(str) {
//            //txtDesc
//            document.getElementById('<%=txtDescDoc.ClientID %>').value = str;
//            document.getElementById('<%=btnDescDoc.ClientID %>').click();
//        }



//        function loadDescDischarge(str) {
//            //txtDesc
//            document.getElementById('<%=txtDesc.ClientID %>').value = str;
//            document.getElementById('<%=btnDescDischarge.ClientID %>').click();
//        }

    </script>
    <div>
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager2" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory">
                <div class="">
                    <div style="text-align: center;">
                        <strong>MRD Reports</strong>
                        <br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Patient&nbsp;</div>
                <table style="width: 100%;">
                    <tr>
                        <td style="text-align: right; width: 20%;">
                            From Date <b>:</b>&nbsp;<%--<uc1:entrydate id="ucDateFrom" runat="server" />--%>
                        </td>
                        <td style="text-align: left; width: 30%;">
                            <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                TabIndex="1" CssClass="ItDoseTextinputText" Width="170px"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                            <%-- &nbsp;<asp:DropDownList ID="ddlyear" runat="server" CssClass="ItDoseDropdownbox">
                </asp:DropDownList>
                <asp:DropDownList ID="ddlMonth" runat="server" CssClass="ItDoseDropdownbox">
                </asp:DropDownList>--%>
                            <%--<asp:Button ID="btnSearch" runat="server" Visible="false" CssClass="ItDoseButton" 
                    Text="Search" />--%>
                        </td>
                        <td style="text-align: right; width: 20%;">
                           To Date <b>:</b>
                            <%--<uc1:entrydate id="ucDateTo" runat="server" />--%>
                        </td>
                        <td style="text-align: left; width: 30%;">
                            <asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                TabIndex="2" CssClass="ItDoseTextinputText" Width="170px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucDateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right; width: 10%;">
                            <div style="display: none;">
                                <asp:TextBox ID="txtDesc" runat="server"></asp:TextBox>
                                <asp:TextBox ID="txtDescSpeciality" runat="server"></asp:TextBox>
                                <asp:TextBox ID="txtDescInvest" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr align="center">
                        <td colspan="6" align="center" style="border:groove">
                            <asp:RadioButtonList ID="rbtnreport" runat="server" Font-Bold="True" Font-Size="8pt"
                                RepeatDirection="Horizontal" Width="836px" Style="text-align: left;" RepeatColumns="4">
                                <asp:ListItem Value="14" Selected="True">Total Registration</asp:ListItem>
                                 <asp:ListItem Value="1">Notifiable Disease</asp:ListItem>
                                <asp:ListItem Value="2">OPD Consultation</asp:ListItem>
                                <asp:ListItem Value="3">Type of Discharge</asp:ListItem>
                                <asp:ListItem Value="4">OPD-IPD Investigation</asp:ListItem>
                                <asp:ListItem Value="5">MLC-Cases</asp:ListItem>
                                <asp:ListItem Value="6">Death Case</asp:ListItem>
                                <asp:ListItem Value="7">Department Wise Admission-Discharge</asp:ListItem>
                                <asp:ListItem Value="8">Birth Statistic</asp:ListItem>
                                <asp:ListItem Value="9">Statistics</asp:ListItem>
                                <asp:ListItem Value="10">Major Minor Surgery</asp:ListItem>
                                <asp:ListItem Value="12">Major Surgery Dept Wise</asp:ListItem>
                                <asp:ListItem Value="13">Major Surgery Doctor Wise</asp:ListItem>
                               <%-- <asp:ListItem Value="11">MRD Brought Death</asp:ListItem>--%>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                        </td>
                        <td>
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </td>
                    </tr>
                    <tr align="center">
                        <td colspan="5" style="text-align: center; width: 100%;">
                            <asp:Button ID="btnissue" Text="Report" CssClass="ItDoseButton" runat="server" 
                                OnClick="btnissue_Click" style="height: 26px" />
                            &nbsp;&nbsp;
                            <asp:Button ID="btnexcel" Text="Export To Excel" CssClass="ItDoseButton" runat="server"
                                ValidationGroup="doc" OnClick="btnexcel_Click" />
                            <div style="display: none;">
                                <asp:Button ID="btnDesc" runat="server" OnClick="Button1_Click" Text="Button" CssClass="ItDoseButton"/>
                                <asp:Button ID="btnDescSpeciality" runat="server" Text="Speciality" OnClick="btnDescSpeciality_Click"  CssClass="ItDoseButton"/>
                                <asp:Button ID="btnDescDischarge" runat="server" Text="Button" OnClick="btnDescDischarge_Click" CssClass="ItDoseButton"/>
                                <asp:Button ID="btnDescInvest" runat="server" Text="Invest" OnClick="btnDescInvest_Click" CssClass="ItDoseButton"/>
                            </div>
                        </td>
                    </tr>
                    <tr align="center">
                        <td align="center" colspan="5">
                            <asp:Label ID="lbldetail" runat="server" Font-Bold="True" Font-Size="10pt" Width="187px"></asp:Label>
                            &nbsp; &nbsp;
                            <asp:Panel ID="Panel1" runat="server" Height="250px" Width="100%" ScrollBars="Auto">
                                <asp:GridView ID="grddetail" CssClass="GridViewStyle" Width="100%" runat="server">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle"  />
                                    <RowStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" VerticalAlign="Middle" />
                                </asp:GridView>
                            </asp:Panel>
                            &nbsp;
                        </td>
                    </tr>
                    <tr align="center">
                        <td align="center" colspan="5">
                            <asp:Label ID="lblsummary" runat="server" Font-Bold="True" Font-Size="10pt" Width="248px"></asp:Label><asp:Panel
                                ID="Panel2" runat="server" Height="250px" Width="450px" ScrollBars="Auto">
                                <asp:GridView ID="grdsummary" CssClass="GridViewStyle" Width="450px" runat="server"
                                    AllowPaging="True">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:GridView>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style="text-align: center">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="pnlconsultation" CssClass="pnlOrderItemsFilter" runat="server" Style="display: none;">
        <div style="text-align: center;">
            DoctorWiseDetail</div>
        <br />
        <div class="content">
            <div style="display: none;">
                <asp:TextBox ID="txtDescDoc" runat="server"></asp:TextBox>
            </div>
            <div style="display: none;">
                <asp:Button ID="btnDescDoc" runat="server" Text="Button" OnClick="btnDescDoc_Click" CssClass="ItDoseButton"/>
            </div>
            <br />
            <div style="text-align: center;">
                <asp:Button ID="btnExportConsult" runat="server" Text="ExportToExcel" OnClick="btnExportConsult_Click"
                    Visible="false" CssClass="ItDoseButton"/>
            </div>
            <asp:GridView ID="grddetailnew" CssClass="GridViewStyle" Width="800px" runat="server">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle" />
            </asp:GridView>
            <br />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton"/>
        </div>
        <div style="display: none;">
            <asp:Button ID="tnhiddendtl" runat="server" CssClass="ItDoseButton"/>
        </div>
        <asp:Panel ID="pnlconsultationdtl" runat="server" CssClass="pnlOrderItemsFilter"
            Style="display: none" ScrollBars="Auto">
            <div style="text-align: center;">
                <asp:Button ID="btnExportConsultdtl" runat="server" Text="ExportToExcel" Visible="false"
                    OnClick="btnExportConsultdtl_Click" CssClass="ItDoseButton"/>
            </div>
            <br />
            <div class="content" style="width: 850px; height: 500px;">
                <asp:GridView ID="grddetailnewdtl" CssClass="GridViewStyle" runat="server">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:GridView>
                <br />
                <asp:Button ID="btncancledtl" runat="server" Text="Close" CssClass="ItDoseButton"/>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeconsultationdtl" runat="server" TargetControlID="tnhiddendtl"
            PopupControlID="pnlconsultationdtl" CancelControlID="btncancledtl" BackgroundCssClass="filterPupupBackground"
            X="50" Y="50">
        </cc1:ModalPopupExtender>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeconsultation" runat="server" TargetControlID="btnHidden"
        DropShadow="true" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlconsultation"
        CancelControlID="btnCancel" />
    <asp:Panel ID="pnlInvest" CssClass="pnlOrderItemsFilter" runat="server" Style="display: none;"
        ScrollBars="Auto">
        <div style="text-align: center;">
            InvestigationDetail</div>
        <br />
        <div class="content" style="height: 400px; width: 800px;">
            <asp:GridView ID="grddetailInvest" CssClass="GridViewStyle" runat="server">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle" />
            </asp:GridView>
            <br />
            <div style="text-align: center;">
                <asp:Button ID="btncancelInvest" runat="server" Text="Cancel" CssClass="ItDoseButton"/>
            </div>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeInvest" runat="server" TargetControlID="btnHidden"
        DropShadow="true" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlInvest"
        CancelControlID="btncancelInvest" />
    <asp:Panel ID="pnlSpeciality" CssClass="pnlOrderItemsFilter" runat="server" Style="display: none;">
        <div style="text-align: center;">
            DoctorWiseAdmitDischargeDetail</div>
        <br />
        <div class="content">
            <div style="display: none;">
                <asp:TextBox ID="txtDescSpecialitydtl" runat="server"></asp:TextBox>
                <asp:Button ID="btnDescSpecialitydtl" runat="server" Text="Button" OnClick="btnDescSpecialitydtl_Click" CssClass="ItDoseButton"/>
            </div>
            <br />
            <div style="text-align: center;">
                <asp:Button ID="btnExportSpeciality" runat="server" Text="ExportToExcel" Visible="false"
                    OnClick="btnExportSpeciality_Click" CssClass="ItDoseButton"/>
            </div>
            <asp:GridView ID="grddetailSpeciality" CssClass="GridViewStyle" Width="800px" runat="server">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle" />
            </asp:GridView>
            <br />
            <asp:Button ID="btnCancelSpeciality" runat="server" Text="Cancel" CssClass="ItDoseButton"/>
        </div>
        <div style="display: none;">
            <asp:Button ID="btnhiddenSpecialitydtl" runat="server" CssClass="ItDoseButton"/>
        </div>
        <asp:Panel ID="pnlSpecialitydtl" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none"
            ScrollBars="Auto">
            <div style="text-align: center;">
                <asp:Button ID="btnExportSpecialitydtl" runat="server" Text="ExportToExcel" Visible="false"
                    OnClick="btnExportSpecialitydtl_Click" CssClass="ItDoseButton"/>
            </div>
            <br />
            <div class="content" style="width: 900px; height: 500px;">
                <asp:GridView ID="grddetailSpecialitydtl" CssClass="GridViewStyle" runat="server">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                </asp:GridView>
                <br />
                <asp:Button ID="btnCancelSpecialitydtl" runat="server" Text="Close" CssClass="ItDoseButton"/>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeSpecialitydtl" runat="server" TargetControlID="btnhiddenSpecialitydtl"
            PopupControlID="pnlSpecialitydtl" CancelControlID="btnCancelSpecialitydtl" BackgroundCssClass="filterPupupBackground"
            X="50" Y="50">
        </cc1:ModalPopupExtender>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeSpeciality" runat="server" TargetControlID="btnHidden"
        DropShadow="true" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlSpeciality"
        CancelControlID="btnCancelSpeciality" />
    <asp:Panel ID="pnlDischage" CssClass="pnlOrderItemsFilter" runat="server" Style="display: none;"
        ScrollBars="Auto">
        <div style="text-align: center;">
            Search Creiteria</div>
        <div style="text-align: center;">
            <asp:Button ID="btnExportDisDetail" runat="server" Text="ExportToExcel" Visible="false"
                OnClick="btnExportDisDetail_Click" CssClass="ItDoseButton"/>
        </div>
        <br />
        <div class="content" style="width: 900px; height: 500px;">
            <asp:GridView ID="grdDescdisc" CssClass="GridViewStyle" runat="server">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle" />
            </asp:GridView>
            <br />
            <asp:Button ID="btnCanceldisc" runat="server" Text="Cancel" CssClass="ItDoseButton"/>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpedicharge" runat="server" TargetControlID="btnHidden"
        DropShadow="true" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDischage"
        CancelControlID="btnCanceldisc" />
</asp:Content>
