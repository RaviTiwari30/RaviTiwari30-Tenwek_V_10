<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="InvestigationSequence.aspx.cs" Inherits="Design_Lab_InvestigationSequence" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <script type="text/javascript">
        function BindDepartment() {
            jQuery("#ddlDepartment option").remove();
            $.ajax({
                url: "InvestigationSequence.aspx/BindDepartment",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null || data != "") {
                        jQuery("#ddlDepartment").append(jQuery("<option></option>").val('0').html("--Select--"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlDepartment').append($("<option></option>").val(data[i].ObservationType_ID).html(data[i].Name));
                        }
                    }
                }
            });
        }
        function BindInvestigation() {
            $('#btnSearch').text("Updating...").attr('disabled', 'disabled');
            $.ajax({
                type: "POST",
                data: '{ObservationType_ID:"' + $('#ddlDepartment').val() + '"}',
                url: "InvestigationSequence.aspx/BindInvestigation",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    INVHeader = jQuery.parseJSON(result.d);
                    if (INVHeader != null) {
                        var output = $('#tb_INVHeader').parseTemplate(INVHeader);
                        $('#INVSearchOutput').html(output);
                        $('#INVSearchOutput').show();
                        $('#btnSearch').show();
                        $('#btnSearch').text("Update").removeAttr('disabled');
                        BindReportType();
                        CheckCondition();
                    }
                    else {
                        $('#INVSearchOutput').html();
                        $('#INVSearchOutput').hide();
                        $('#btnSearch').hide();
                        $('#btnSearch').text("Update").removeAttr('disabled');
                    }
                    condition();

                    $('#tb_grdINV').tableDnD({
                        onDragClass: "myDragClass",

                        onDragStart: function (table, row) {
                         //   $("#lblMsg").text('');
                            // $("#debugArea").html("Started dragging row " + row.id);
                            modelAlert("Started dragging row " + row.id);
                        },
                        dragHandle: ".dragHandle"

                    });


                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#debugArea").html("");
                    modelAlert('Error occurred, Please contact administrator');
                   // $("#lblMsg").text('Error occurred, Please contact administrator');
                    $('#btnSearch').text("Update").removeAttr('disabled');
                }

            });
        }
        function BindReportType() {
            jQuery("#tb_grdINV tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    if (jQuery.trim($rowid.find("#spnreporttype").text()) != "")
                        jQuery.trim($rowid.find("#ddlReportType").val(jQuery.trim($rowid.find("#spnreporttype").text())));
                }
            });
        }
        $(document).ready(function () {
            BindDepartment()
            //  BindInvestigation()

        });

        function condition() {
            if ($('#tb_grdINV tr').length > 0) {
                $("#divINV").show(); $("#divINV1").show();
                $("#btnSearch").removeProp('disabled');
            }
            else {
                $("#btnSearch").prop('disabled', 'disabled');
                $("#divINV").hide(); $("#divINV1").hide();
            }
        }

        function chngcurmove() {
            document.body.style.cursor = 'move';
        }
        function SaveInvestigation() {
            $("#btnSearch").prop('disabled', 'disabled');

            if ($('#tb_grdINV tr').length > 0) {
                var INV = [];
                var counter = 0;
                $("#tb_grdINV tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        var printseperate = 0;
                        if ($(this).find("#chkPrintSepearate").is(":checked"))
                            printseperate = 1;
                        else
                            printseperate = 0;
                        var Outsource = 0;
                        var OutSourceLabID = "0";
                        if ($(this).find("#chkOurSource").is(":checked")) {
                            Outsource = 1;
                            if ($(this).find("#ddlLabOutSource").val() != "") {
                                OutSourceLabID = $(this).find("#ddlLabOutSource").val();
                            }
                        }
                        else
                            Outsource = 0;

                        INV.push({ "InvestigationID": $.trim($rowid.find("#tdInvestigationID").text()), "SequenceNo": id, "PrintSeparate": printseperate, "OutSource": Outsource, "ReportType": $.trim($rowid.find("#ddlReportType").val()), "OutSourceLabID": OutSourceLabID });
                    }
                });
                if (counter > 0) {
                    $("#btnSearch").removeProp('disabled');
                    modelAlert('Please Select OutSource Lab');
                   // $("#lblMsg").text('Please Select OutSource Lab');
                    return false;
                }
                else if (INV.length > "0") {
                    $.ajax({
                        type: "POST",
                        data: JSON.stringify({ Data: INV }),
                        url: "InvestigationSequence.aspx/SaveInvestigation",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            INVHeader = (result.d);
                            if (INVHeader == "1") {
                                $("#debugArea").html("");
                                // $("#lblMsg").text('Record Saved Successfully');
                                
                                modelAlert('Record Saved Successfully', function (response) {
                                    BindInvestigation();
                                });
                             
                            }
                            else {
                                $("#debugArea").html("");
                                modelAlert('Error occurred, Please contact administrator', function (response) {
                                    BindInvestigation();
                                }); 
                            }

                            $("#btnSearch").removeProp('disabled');
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            modelAlert('Error occurred, Please contact administrator');
                            // $("#lblMsg").text('Error occurred, Please contact administrator');
                            $("#btnSearch").removeProp('disabled');
                            $("#debugArea").html("");
                        }

                    });
                }
            }
        }
        function ChangeReportType(rowid) {
            var Retype = $(rowid).val();
            jQuery("#tb_grdINV tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    jQuery.trim($rowid.find("#ddlReportType").val(Retype));
                }
            });
        }
        function ChangeOutSourceLabType(rowid) {
            var OutSourcelab = $(rowid).val();
            jQuery("#tb_grdINV tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    if ($rowid.find("#chkOurSource").is(":checked")) {
                        jQuery.trim($rowid.find("#ddlLabOutSource").val(OutSourcelab));
                    }
                }
            });
        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b> Investigation Sequence Master </b> <br /> 
                               <span id="lblMsg" class="ItDoseLblError"></span>
         <span id="debugArea" class="ItDoseLblError"></span>  
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-7"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                              Department Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <select id="ddlDepartment" onchange="BindInvestigation()"></select>
                        </div>
                         <div class="col-md-8"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory" id="divINV">
             <div class="Purchaseheader">
                     Search Result
                </div>

             <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="INVSearchOutput" style="max-height: 450px; overflow-x: auto;">
                        </div>
                       
                       
                    </td>
                </tr>
            </table>
             </div>

        <div class="POuter_Box_Inventory" style="text-align:center;display:none" id="divINV1">
            <input type="button" value="Update" id="btnSearch" class="ItDoseButton" onclick="SaveInvestigation()" />
        </div>
    </div>



                <script id="tb_INVHeader" type="text/html">
    <table  width="100%" cellspacing="0" rules="all" border="1" id="tb_grdINV"
    style="border-collapse:collapse;"  class="GridViewStyle">
		<tr id="Header">        
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:320px;">Investigation Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Print Sequence No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Print Separate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">OutSource</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:190px;">OutSource Lab Name
                <select id="ddlOutSourceHeader" clientidmode="Static" style="width:150px;display:none" runat="server" onchange="ChangeOutSourceLabType(this)"></select></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:190px;">Report Type
                <select id="ddlHeREporttype" onchange="ChangeReportType(this)">
                    <option></option>
                <option value="1">Numeric Report</option>
                <option value="3">Text Report</option>
                <option value="5">Radiology Report</option>
             </select></th>
             <th class="GridViewHeaderStyle" scope="col" style="width:190px; display:none">Investigation ID</th>	        
		</tr>
        <#       
        var dataLength=INVHeader.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = INVHeader[j];
        #>
                    <tr id="<#=j+1#>">                                                                                                                  
                    <td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdHeaderName" onmouseover="chngcurmove()"  style="width:320px;" ><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="tdSeqNo" onmouseover="chngcurmove()" style="width:60px; text-align:center " ><#=objRow.Print_Sequence#></td>
                    <td class="GridViewLabItemStyle" id="tdPrintSeparate"  style="width:60px; text-align:center;cursor:pointer">
                           <#if(objRow.PrintSeperate =="1"){#>    
                     <input type="checkbox"  id="chkPrintSepearate" checked="checked" />
                         <#}
                        else
                        {#>                  
                     <input type="checkbox"  id="chkPrintSepearate" /> 
                        <#}#>   
                        </td>
                        <td class="GridViewLabItemStyle" id="tdOutSource"  style="width:60px; text-align:center;cursor:pointer">
                           <#if(objRow.IsOutSource =="1"){#>    
                     <input type="checkbox"  id="chkOurSource" checked="checked" onclick="OutSource(this);"/>
                         <#}
                        else
                        {#>                  
                     <input type="checkbox"  id="chkOurSource" onclick="OutSource(this);" /> 
                        <#}#> 
                           
                        </td>
                        <td  class="GridViewLabItemStyle" id="tdOutSourceName"  style="width:190px; text-align:center;cursor:pointer">
                               <span id="spnOurSource" style="display:none"><#=objRow.OutSourceLabID#></span>
                            <select id="ddlLabOutSource" runat="server" clientidmode="Static" style="width:150px" ></select>
                        </td>
                          <td class="GridViewLabItemStyle" id="tdReportType"  style="width:190px; text-align:center;cursor:pointer"><span id="spnreporttype" style="display:none"><#=objRow.ReportType#></span>
                    <select id="ddlReportType" style="width:150px">
                        <option value="1">Numeric Report</option>
                        <option value="3">Text Report</option>
                        <option value="5">Radiology Report</option>
                    </select>
                      
                        </td>
                    <td class="GridViewLabItemStyle" id="tdInvestigationID"  style="width:60px; display:none" ><#=objRow.Investigation_id#></td>

                        
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>
    <script type="text/javascript">
        function OutSource(rowid) {
            var id = jQuery(rowid).attr("id");
            var $rowid = jQuery(rowid).closest("tr");
            if (id != "Header") {
                if ($rowid.find("#chkOurSource").is(':checked')) {
                    jQuery.trim($rowid.find("#ddlLabOutSource").removeAttr('disabled'));
                }
                else {
                    jQuery.trim($rowid.find("#ddlLabOutSource").attr('disabled', 'disabled'));
                    jQuery.trim($rowid.find("#ddlLabOutSource").val('0'));
                }
            }
        }
        function CheckCondition() {
            jQuery("#tb_grdINV tr").each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    if ($rowid.find("#chkOurSource").is(':checked')) {
                        if (jQuery.trim($rowid.find("#spnOurSource").text()) != '') {
                            $rowid.find("#ddlLabOutSource").val(jQuery.trim($rowid.find("#spnOurSource").text()));
                            $rowid.find("#ddlLabOutSource").removeAttr('disabled');
                        }
                    }
                    else
                        $rowid.find("#ddlLabOutSource").attr('disabled', 'disabled');
                }
            });
        }
    </script>
</asp:Content>

