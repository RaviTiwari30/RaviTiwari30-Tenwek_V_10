<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="HeaderMaster.aspx.cs" Inherits="Design_EMR_HeaderMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <script type="text/javascript">
        function bindHeader() {
            $.ajax({
                type: "POST",
                data: '{}',
                url: "Services/EMR.asmx/bindEMRHeader",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    EMRHeader = jQuery.parseJSON(result.d);
                    if (EMRHeader != null) {
                        var output = $('#tb_EMRHeader').parseTemplate(EMRHeader);
                        $('#EMRSearchOutput').html(output);
                        $('#EMRSearchOutput').show();

                    }
                    else {
                        $('#EMRSearchOutput').html();
                        $('#EMRSearchOutput').hide();

                    }
                    condition();

                    $('#tb_grdEMR').tableDnD({
                        onDragClass: "myDragClass",

                        onDragStart: function (table, row) {
                            $("#lblMsg").text('');
                            $("#debugArea").html("Started dragging row " + row.id);
                        },
                        dragHandle: ".dragHandle"

                    });


                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#debugArea").html("");
                    $("#lblMsg").text('Error occurred, Please contact administrator');

                }

            });
        }
        $(document).ready(function () {
            bindHeader();
            condition();

        });

        function condition() {
            if ($('#tb_grdEMR tr').length > 0) {
                $("#divEMR").show(); $("#divEMR1").show();
                $("#btnSaveEMR").removeProp('disabled');
            }
            else {
                $("#btnSaveEMR").prop('disabled', 'disabled');
                $("#divEMR").hide(); $("#divEMR1").hide();
            }
        }


        function saveEMRHeader() {
            $("#btnSave").attr('disabled', 'disabled');
            if ($.trim($("#txtHeader").val()) != "") {
                $("#lblMsg").text('');
                $.ajax({
                    type: "POST",
                    data: '{HeaderName:"' + $.trim($("#txtHeader").val()) + '"}',
                    url: "Services/EMR.asmx/saveEMRHeader",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        EMRHeader = (result.d);
                        if (EMRHeader == "1") {
                            $("#debugArea").html("");
                            $("#lblMsg").text('Record Saved Successfully');
                            bindHeader();
                            $("#txtHeader").val('');
                        }
                        else {
                            $("#debugArea").html("");
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                            bindHeader();
                        }
                        $("#btnSave").removeAttr('disabled').val('Save');
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#debugArea").html("");
                        $("#lblMsg").text('Error occurred, Please contact administrator');

                    }

                });
            }
            else {
                $("#debugArea").html("");
                $("#lblMsg").text('Please Enter Header Name');
                $("#txtHeader").focus();
                $("#btnSave").removeAttr('disabled').val('Save');
            }
        }
        function chngcurmove() {
            document.body.style.cursor = 'move';
        }
        function saveEMRTable() {
            $("#btnSaveEMR").prop('disabled', 'disabled');
            if ($('#tb_grdEMR tr').length > 0) {
                var EMR = [];
                $("#tb_grdEMR tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        EMR.push({ "SNo": $(this).attr("id"), "HeaderID": $.trim($rowid.find("#tdHeaderID").text()), "HeaderName": $.trim($rowid.find("#tdHeaderName").text()), "SequenceNo": $.trim($rowid.find('#tdSeqNo').text()), "Active": $.trim($rowid.find('#tdActive input[type:radio]:checked').val()) });
                    }
                });
                if (EMR.length > "0") {
                    $.ajax({
                        type: "POST",
                        data: JSON.stringify({ EMR: EMR }),
                        url: "Services/EMR.asmx/saveEMRHeaderTable",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            EMRHeader = (result.d);
                            if (EMRHeader == "1") {
                                $("#debugArea").html("");
                                $("#lblMsg").text('Record Saved Successfully');
                                bindHeader();
                            }
                            else {
                                $("#debugArea").html("");
                                $("#lblMsg").text('Error occurred, Please contact administrator');
                                bindHeader();
                            }

                            $("#btnSaveEMR").removeProp('disabled');
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                            $("#btnSaveEMR").removeProp('disabled');
                            $("#debugArea").html("");
                        }

                    });
                }
            }
        }

    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b> Header Master </b> <br /> 
                               <span id="lblMsg" class="ItDoseLblError"></span>
         <span id="debugArea" class="ItDoseLblError"></span>  
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Header Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type ="text" maxlength="40" class="requiredField" id="txtHeader" tabindex="1" title="Enter Header Name" />
                        </div>
                      
                    </div>
                    <div class="row" style="text-align:center;">
                         <input type ="button"  value="Save" id="btnSave" tabindex="2" title="Click To Save"  class="ItDoseButton" onclick="saveEMRHeader()"/>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
         
        </div>
         <div class="POuter_Box_Inventory" id="divEMR">
             <div class="Purchaseheader">
                     Header Detail
                </div>

             <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="EMRSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                       
                       
                    </td>
                </tr>
            </table>
             </div>

        <div class="POuter_Box_Inventory" style="text-align:center" id="divEMR1">
            <input type="button" value="Save" id="btnSaveEMR" class="ItDoseButton" onclick="saveEMRTable()" />
        </div>
    </div>



                <script id="tb_EMRHeader" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdEMR"
    style="border-collapse:collapse;width:100%;"  class="GridViewStyle">
		<tr id="Header">        
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:320px;">Header Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Sequence No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:190px;">Active</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:190px; display:none">HeaderID</th>
					        
		</tr>
        <#       
        var dataLength=EMRHeader.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = EMRHeader[j];
        #>
                    <tr id="<#=j+1#>">                                                                                                                  
                    <td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdHeaderName" onmouseover="chngcurmove()"  style="width:320px;" ><#=objRow.HeaderName#></td>
                    <td class="GridViewLabItemStyle" id="tdSeqNo" onmouseover="chngcurmove()" style="width:60px; text-align:center " ><#=objRow.SeqNo#></td>
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:190px; text-align:center;cursor:pointer">
                        <input type="radio" value="1" id="rdoActive"  name="<#=j+1#>"
                             <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #>                            
                             ><#=objRow.Active#> </input> <input type="radio" value="0" id="rdoDeActive"  name="<#=j+1#>"
                                  <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #> ><#=objRow.DeActive#></input>
                        </td>
                    <td class="GridViewLabItemStyle" id="tdHeaderID"  style="width:60px; display:none" ><#=objRow.Header_ID#></td>

                        
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>

</asp:Content>

