<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="MasterCreation.aspx.cs"
    Inherits="Design_Equipment_Masters_MasterCreation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <style type="text/css">
        .accordionContent
        {
            background-color: #D3DEEF;
            border-color: -moz-use-text-color #2F4F4F #2F4F4F;
            border-right: 1px dashed #2F4F4F;
            border-style: none dashed dashed;
            border-width: medium 1px 1px;
            padding: 10px 5px 5px;
        }

        .accordionHeaderSelected
        {
            background-color: #5078B3;
            border: 1px solid #2F4F4F;
            color: white;
            cursor: pointer;
            font-family: Arial,Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            margin-top: 5px;
            padding: 5px;
        }

        .accordionHeader
        {
            background-color: #2E4D7B;
            border: 1px solid #2F4F4F;
            color: white;
            cursor: pointer;
            font-family: Arial,Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            margin-top: 5px;
            padding: 5px;
        }

        .href
        {
            color: White;
            font-weight: bold;
            text-decoration: none;
        }
    </style>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content">
                <div style="text-align: center;">
                    <b><%-->Master Creation--%></b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>

            </div>
            <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
        </div>
        <table>
            <tr>
                <td style="vertical-align: top; width: 250px;">
                    <cc1:Accordion ID="Accordion1" runat="server" SelectedIndex="0" HeaderCssClass="accordionHeader"
                        HeaderSelectedCssClass="accordionHeaderSelected" ContentCssClass="accordionContent" FadeTransitions="true" SuppressHeaderPostbacks="true" TransitionDuration="250" FramesPerSecond="40" RequireOpenedPane="false" AutoSize="None">
                        <Panes>
                            <cc1:AccordionPane ID="AccPan1" runat="server">
                                <Header>Master</Header>
                                <Content>

                                    <a href="AssetTypemaster.aspx" target="iframeMaster">Asset Type</a><br />
                                    <%--<a href="AssetSubTypemaster.aspx" target="iframeMaster">Asset SubType</a><br />--%>
                                    <%--<a href="FloorMaster.aspx" target="iframeMaster">Floor Master</a><br />                                    
                                    <a href="LocationMaster.aspx" target="iframeMaster">Location Master</a><br />--%>

                                    <a href="RoomMaster.aspx" target="iframeMaster">Room Master</a><br />
                                    <%--<a href="CallTypeMaster.aspx" target="iframeMaster">Call Type</a><br />--%>
                                    <%--<a href="ProblemTypeMaster.aspx" target="iframeMaster">Problem Type</a><br />--%>
                                    <a href="AMCTypeMaster.aspx" target="iframeMaster">AMC Type</a><br />
                                    <%--<a href="ProviderAMC.aspx" target="iframeMaster">AMC Provider Master</a><br />        --%>
                                    <%--<a href="MaintenanceTypeMaster.aspx" target="iframeMaster">Maintenance Type</a><br />
                                    <a href="MaintenanceMaster.aspx" target="iframeMaster">Maintenance Master</a><br />--%>
                                    <%--<a href="AccessoryMaster.aspx" target="iframeMaster">Accessory Master</a><br />--%>
                                    <a href="SupplierTypeMaster.aspx" target="iframeMaster">Supplier Type Master</a><br />
                                    <a href="SupplierMaster.aspx" target="iframeMaster">Vendor Master</a><br />
                                    <%--<a href="ServiceSupplierMaster.aspx" target="iframeMaster">ServiceSupplier Master</a><br />--%>
                                    <%-- <a href="TechnicianMaster.aspx" target="iframeMaster">Technician Master</a><br />--%>
                                    <%--<a href="AssetMasterGRN.aspx" target="iframeMaster">Asset Master - FROM GRN </a><br />--%>
                                    <%--<a href="ProviderInsurance.aspx" target="iframeMaster">Insurance Provider Master </a><br />
                                    <a href="Insurance.aspx" target="iframeMaster">Insurance </a><br />--%>
                                    <%-- <a href="EquipmentLocation.aspx" target="iframeMaster">Equipment Location </a><br />--%>
                                    <%--<a href="AssetScheduling.aspx" target="iframeMaster">Asset Scheduling</a><br />--%>
                                </Content>
                            </cc1:AccordionPane>
                            <cc1:AccordionPane ID="AccPan2" runat="server">
                                <Header>Transaction</Header>
                                <Content>
                                    <a href="AssetWoGRN.aspx" target="iframeMaster">Add Asset</a><br />
                                    <a href="EditAssetWoGRN.aspx" target="iframeMaster">Edit Asset</a><br />
                                    <a href="ChangeLocation.aspx" target="iframeMaster">Change Location </a>
                                    <br />
                                    <a href="caliberationtype.aspx" target="iframeMaster">Calibration Type</a><br />
                                    <a href="PMS.aspx" target="iframeMaster">Preventive Mainenance Schedule</a><br />
                                    <%--<a href="ComplainRegister.aspx" target="iframeMaster">Complaint Register</a>

                                    <a href="../Transactions/RequestRegister.aspx" target="iframeMaster">Request Register</a><br />
                                    <a href="../Transactions/RequestAcceptance.aspx" target="iframeMaster">Request Acceptance</a><br />
                                    <a href="../Transactions/OutsideMaintenance.aspx" target="iframeMaster">Outside Maintenance</a><br />
                                    <a href="../Transactions/InHouseMaintenace.aspx" target="iframeMaster">In-House Maintenace</a><br />                                    
                                    <a href="../Transactions/WarrantyMaintenance.aspx" target="iframeMaster">Warranty Maintenancer</a><br />
                                    <a href="../Transactions/AssetSchedulingTrans.aspx" target="iframeMaster">Asset Scheduling</a><br />
                                    <a href="../Transactions/AssetSchedulingCompletion.aspx" target="iframeMaster">Asset Scheduling Completion</a><br />
                                    <a href="../Transactions/AssetDeActivationRequest.aspx" target="iframeMaster">Asset DeActivation Request</a><br />
                                    <a href="../Transactions/AssetDeactivationApproval.aspx" target="iframeMaster">Asset Deactivation Approval</a><br />
                                    <a href="../Transactions/AttachmentDetails.aspx" target="iframeMaster">Attachment Details</a><br />--%>
                                </Content>
                            </cc1:AccordionPane>
                            <cc1:AccordionPane ID="AccordionPane1" runat="server">
                                <Header>Reports</Header>
                                <Content>
                                    <a href="../Reports/AssetReport.aspx" target="iframeMaster">Asset Report</a><br />
                                    <a href="AssetTypeReport.aspx" target="iframeMaster">Machine PMS Report</a>
                                </Content>
                            </cc1:AccordionPane>
                        </Panes>
                    </cc1:Accordion>
                </td>
                <td style="vertical-align: top;">
                    <div class="POuter_Box_Inventory" style="height: 540px;width:1040px">
                        <iframe id="iframeMaster" name="iframeMaster" src="" style="background-color: #FFFFFF; margin-left: 0px; margin-top: 0px;"
                            frameborder="0" enableviewstate="true" height="538px" width="100%"></iframe>
                    </div>
                </td>
            </tr>
        </table>

    </div>



</asp:Content>
