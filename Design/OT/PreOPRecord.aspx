<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PreOPRecord.aspx.cs" Inherits="PreOPRecord" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script src="../../Scripts/chosen.jquery.min.js"></script>
    <link href="../../Styles/chosen.css" rel="stylesheet" />

</head>
<script type="text/javascript">
    $(document).ready(function () {
        $(".ddlDoctor").chosen();
        BindDoctor();
        $("#ddlSurgeon").change(function () {
            var selectedSurgon = $("#ddlSurgeon").val();
            $("#hdnddlSurgeon").val(selectedSurgon);

        })
        if ($("#hdnddlSurgeon").val() != "0") {
            $("#ddlSurgeon").val($("#hdnddlSurgeon").val());
            $("#ddlSurgeon").trigger("chosen:updated")
        }

        $("#ddlAnaesthist").change(function () {
            var selectedAnaesthist = $("#ddlAnaesthist").val();
            $("#hdnddlAnaesthist").val(selectedAnaesthist);

        })
        if ($("#hdnddlAnaesthist").val() != "0") {
            $("#ddlAnaesthist").val($("#hdnddlAnaesthist").val());
            $("#ddlAnaesthist").trigger("chosen:updated")
        }

    })

    function BindDoctor() {
        var ddlDoctor = $('.ddlDoctor');
        $(".ddlDoctor option").remove();
        var Doctor = {
            type: "POST",
            url: "../common/CommonService.asmx/bindDoctor",
            data: '{ }',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,
            success: function (result) {
                Doctor = jQuery.parseJSON(result.d);
                if (Doctor != null) {
                    $(".ddlDoctor").chosen('destroy');
                    $(".ddlDoctor").append(jQuery("<option></option>").val("ALL").html("Select"));
                    if (Doctor.length == 0) {
                        $(".ddlDoctor").append(jQuery("<option></option>").val("ALL").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < Doctor.length; i++) {
                            $(".ddlDoctor").append(jQuery("<option></option>").val(Doctor[i].Doctor_ID).html(Doctor[i].Name));
                        }
                    }
                }
                $(".ddlDoctor").chosen();
            },
            error: function (xhr, ajaxOptions, thrownError) {
                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
            }
        };
        $.ajax(Doctor);
    }

</script>

<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:Label ID="Transaction_ID" runat="server" Style="display: none" />
            <asp:Label ID="PatientId" runat="server" Style="display: none" />
            <asp:Label ID="App_ID" runat="server" Style="display: none" />
            <asp:Label ID="OTBookingID" runat="server" Style="display: none" />
            <asp:Label ID="OTNumber" runat="server" Style="display: none" />
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    <b>PRE OP Record</b><br />
                </div>

                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                 <div class="row">
                    <div class="col-md-25" style="display: block;">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Original Ward</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtOriginalWard" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Arrival in Recovery </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                  <asp:TextBox ID="txtArrivalRecovery" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText"></asp:TextBox>
                            </div>                           
                        </div>
                        <div class="row">
                           
                            <div class="col-md-4">
                                <label class="pull-left">Departure From Recovery</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:TextBox ID="txtDepartureRecovery" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputText"></asp:TextBox>
                            </div>
                           
                       
                            <div class="col-md-4">
                                <label class="pull-left">Surgeon</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                              <asp:DropDownList ID="ddlSurgeon" CssClass="ddlDoctor" ClientIDMode="Static" runat="server"></asp:DropDownList>
                            <asp:HiddenField ID="hdnddlSurgeon" ClientIDMode="Static" Value="0" runat="server" />                         
                            </div>
                         </div>

                        <div class="row">                           
                            <div class="col-md-4">                               
                            </div>
                            <div class="col-md-7">                                 
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Additional Doctors</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                   <asp:TextBox ID="txtAdditionalDoctors" runat="server" TextMode="MultiLine"></asp:TextBox>                 
                            </div>
                         </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Anaesthist</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                   <asp:DropDownList ID="ddlAnaesthist" CssClass="ddlDoctor" ClientIDMode="Static" runat="server"></asp:DropDownList>
                            <asp:HiddenField ID="hdnddlAnaesthist" ClientIDMode="Static" Value="0" runat="server" />
                            </div>
                           
                     
                         <div class="col-md-4">
                                <label class="pull-left">Conscious</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                               <asp:TextBox ID="txtConscious" runat="server" ClientIDMode="Static"></asp:TextBox>

                         
                            </div>
                            </div>
                        <div class="row">
                          <div class="col-md-4">
                                <label class="pull-left">BP</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:TextBox ID="txtRP" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                           
                       
                            <div class="col-md-4">
                                <label class="pull-left">Colour</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:DropDownList ID="ddlColour" runat="server">
                                <asp:ListItem Value="PINK TONGUE">PINK TONGUE</asp:ListItem>
                                <asp:ListItem Value="PALE">PALE</asp:ListItem>
                                <asp:ListItem Value="CYANOSED">CYANOSED</asp:ListItem>
                            </asp:DropDownList>
                            </div>
                            </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Semi Conscious</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                               <asp:TextBox ID="txtSemiConscious" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                           
                      
                            <div class="col-md-4">
                                <label class="pull-left">Pulse Rate</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                  <asp:TextBox ID="txtPulseRate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            </div>

                         <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Temp</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                               <asp:TextBox ID="txtTemp" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                           
                      
                            <div class="col-md-4">
                                <label class="pull-left">Blood Sugar</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                               <asp:DropDownList ID="ddlParticular" runat="server" ClientIDMode="Static">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="FBS">FBS</asp:ListItem>
                                <asp:ListItem Value="PPBS">PPBS</asp:ListItem>
                                <asp:ListItem Value="RBS">RBS</asp:ListItem>
                                <asp:ListItem Value="PRELU">Pre Lunch</asp:ListItem>
                                <asp:ListItem Value="PREDINN">Pre Dinner</asp:ListItem>
                                <asp:ListItem Value="MiddleOFNight">Middle Of Night</asp:ListItem>

                                <asp:ListItem Value="PostLunch">Post Lunch</asp:ListItem>
                                <asp:ListItem Value="PostDinner">Post Dinner</asp:ListItem>
                                <asp:ListItem Value="PostBreakFast">Post BreakFast</asp:ListItem>

                            </asp:DropDownList>
                            </div>

                             <div class="col-md-4">
                                 <asp:TextBox ID="txtbloodsugar" placeholder="Value (mmol/L)" runat="server"></asp:TextBox>
                             </div>

                            </div>

                        <div class="row">
                             <div class="col-md-4">
                                <label class="pull-left">Conjuntiva</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:TextBox ID="txtConjuntiva" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                           
                        
                            <div class="col-md-4">
                                <label class="pull-left">UnConscious</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtUnconscious" runat="server" ClientIDMode="Static"></asp:TextBox>

                            </div>
                       </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">SPO2</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                    <asp:TextBox ID="txtSPO2" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            
                           
                       
                             <div class="col-md-4">
                                <label class="pull-left">Respiration</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                  <asp:TextBox ID="txtRespiration" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            
                          
                           
                        </div>
                        <div class="row">
                              <div class="col-md-4">
                                <label class="pull-left">Adequte</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                    <asp:TextBox ID="txtAdequate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                             <div class="col-md-4">
                                <label class="pull-left">Depressed</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:TextBox ID="txtDepressed" runat="server" ClientIDMode="Static"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Vomited</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                 <asp:RadioButtonList ID="rdList" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                <asp:ListItem Value="No">No</asp:ListItem>
                            </asp:RadioButtonList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Salivation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                     <asp:CheckBoxList ID="chkList" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="Little">Little</asp:ListItem>
                                <asp:ListItem Value="Moderate">Moderate</asp:ListItem>
                                <asp:ListItem Value="Profuse">Profuse</asp:ListItem>
                            </asp:CheckBoxList>
                            </div>
                             
                           
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Pharynx</label>
                               
                            </div>
                              <div class="col-md-2">
                               <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                 <asp:CheckBoxList ID="chkPharynx" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="DRY">DRY</asp:ListItem>
                                <asp:ListItem Value="WET">WET</asp:ListItem>
                                <asp:ListItem Value="ANY SUUCTION">ANY SUCTION</asp:ListItem>
                            </asp:CheckBoxList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">General Condition on Arrival</label>
                              
                            </div>
                              <div class="col-md-2">
                               <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                               <asp:TextBox ID="txtCondition" runat="server" ClientIDMode="Static" TextMode="MultiLine"></asp:TextBox>
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Pre Op Medication:Name of Drugs,Dose,time,Signature</label>
                              
                            </div>
                            <div class="col-md-2">
                               <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                 <asp:TextBox ID="txtMedication" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        
                           
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">IV Fluids:Name,Total,Volume,Time</label>
                             
                            </div>
                             <div class="col-md-2">
                               <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <asp:TextBox ID="txtIVFluids" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        
                           
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Remarks:Including Any Special Resusciation</label>
                           
                            </div>
                             <div class="col-md-2">
                               <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <asp:TextBox ID="txtRemarks" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        
                           
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Other Specify</label>
                           
                            </div>
                             <div class="col-md-2">
                               <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <asp:TextBox ID="txtOtherSpecification" runat="server" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        
                           
                        </div>

                     </div>
                     </div>
                
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
            </div>
            <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:GridView ID="grdPhysical" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdPhysical_RowCommand" TabIndex="6">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="OriginalWard">
                            <ItemTemplate>
                                <%#Eval("OriginalWard") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Surgeon">
                            <ItemTemplate>
                                <%#Eval("SurgeonName") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Anaesthist">
                            <ItemTemplate>

                                <%#Eval("AnaesthistName") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print" Visible="true">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandName="imbPrint" Visible="true"
                                    CommandArgument='<%# Eval("ID") %>' ImageUrl="~/Images/print.gif" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                TargetControlID="txtArrivalRecovery" AcceptAMPM="True">
            </cc1:MaskedEditExtender>
            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                TargetControlID="txtDepartureRecovery" AcceptAMPM="True">
            </cc1:MaskedEditExtender>

            <div style="display:none">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">Blood Pressure Chart</div>
                    <asp:Chart ID="chartBP" runat="server"  Width="960px" Height="280px" BackColor="WhiteSmoke">                    
                        <Legends>
                            <asp:Legend Name="DefaultLegend" Docking="Top" />
                        </Legends>
                        <Series>
                            <asp:Series ChartType="Line" Name="Systolic" Color="Red" >
                             </asp:Series>
                            <asp:Series ChartType="Line" Name="Diastolic" Color="Blue" >
                            </asp:Series>
                        </Series>
                        <ChartAreas>
                            <asp:ChartArea Name="ChartArea2">
                            </asp:ChartArea>
                        </ChartAreas>
                    </asp:Chart>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">SPO2 Graph</div>
                    <asp:Chart ID="chartPL" runat="server"  Width="960px" Height="270px" BackColor="WhiteSmoke">                    
                        <Legends>
                            <asp:Legend Name="DefaultLegend" Docking="Top" />
                        </Legends>
                        <Series>
                            <asp:Series ChartType="Line" Name="SPO2"   >
                            </asp:Series>
                        </Series>
                        <ChartAreas>
                            <asp:ChartArea Name="ChartArea3">
                            </asp:ChartArea>
                        </ChartAreas>
                    </asp:Chart>
                </div>
           </div>
        </div>
    </form>
</body>

</html>
