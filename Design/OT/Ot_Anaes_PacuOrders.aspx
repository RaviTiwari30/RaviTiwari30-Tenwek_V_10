<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Ot_Anaes_PacuOrders.aspx.cs" Inherits="Design_OT_Ot_Anaes_PacuOrders" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
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
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader" style="text-align: center;">
                    <b>PACU ORDERS</b><br />
                </div>
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
             <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Special Orders
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtSpecialOrders" ClientIDMode="Static" runat="server" Width="970px" Height="80px" TextMode="MultiLine" ToolTip="Enter Pre operative Diagnosis" TabIndex="13"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Comments / Complications in PACU
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtComplications" ClientIDMode="Static" runat="server" Width="970px" Height="90px" TextMode="MultiLine" ToolTip="Enter Post Operative Diagnosis" TabIndex="14"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                             <div class="col-md-4">
                                <label class="pull-left">Anaesthetist</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                   <asp:DropDownList ID="ddlAnaesthist" CssClass="ddlDoctor" ClientIDMode="Static" runat="server"></asp:DropDownList>
                                    <asp:HiddenField ID="hdnddlAnaesthist" ClientIDMode="Static" Value="0" runat="server" />
                            </div> 
                              <div class="col-md-5">
                                <label class="pull-left">Additional Doctors</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                   <asp:TextBox ID="txtAdditionalDoctors" runat="server" TextMode="MultiLine"></asp:TextBox>                 
                            </div> 
                        </div>
                    </div>
                </div>
            </div>
              <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Intra-Operative Incidents
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <asp:TextBox ID="txtIntraOPIncidents" ClientIDMode="Static" runat="server" Width="970px" Height="80px" TextMode="MultiLine" ToolTip="Enter Findings" TabIndex="20"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" />
            </div>
        </div>
    </form>
</body>
</html>
