<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCAgeingBuckets.ascx.cs" Inherits="Design_Controls_UCAgeingBuckets" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript">
     path = "'../../'"
    $(document).ready(function () {
        if ($("#ddlAgeingWho").val() == "Stock")
            path = '../../../';
        $SearchBucketDetails(function () { });
    });


    var $SearchBucketDetails = function (callback) {
        if ($('#ddlAgeingWho').val() == "0")
        {
            $('#dvAgeingBuckets').html('');
            $('#Button1').hide();
            return;
        }
        $('#Button1').show();
        $('#lblMsg').text('');
        var BucketType = $('#ddlBucketType').val();
        var AgeingWho = $('#ddlAgeingWho').val();

        var ServiceURL = "";
        if (Number($("#spnControlforStore").text()) == 1)
            ServiceURL = "../../../Design/Common/CommonService.asmx/bindAgeingBuckets";
        else
            ServiceURL = "../Common/CommonService.asmx/bindAgeingBuckets";

        serverCall(ServiceURL, { bucketType: BucketType, AgeingWho: AgeingWho }, function (response) {
            BucketDetails = JSON.parse(response);
            var outputBucketDetails = $('#tb_BucketDetails').parseTemplate(BucketDetails);
            $('#dvAgeingBuckets').html(outputBucketDetails).customFixedHeader();
            var rowNo = Number($("#tableAgeingBuckets tbody tr").length);
            if (rowNo > 1)
                $("#tableAgeingBuckets tbody tr").not(':last').find('.imgPlus').hide();

            $('#dvList').show();
        });
    }

    var saveBuckets = function (callback) {
        var IsCheck = 0, IsCheckSequenceNo = 0, selectedRowSequence = "", SelectedRowid = "";
        if ($('#ddlAgeingWho').val() == "0") {
            $('#lblMsg').text('Please select the Bucket For');
            $('#ddlAgeingWho').focus();
            return false;
        }
        $('#tableAgeingBuckets tbody tr').each(function (index, row) {
            if (Number($.trim($(row).find('#txtFrom').val())) > Number($.trim($(row).find('#txtTo').val()))) {
                IsCheck = 1;
                SelectedRowid = row;
            }
            if (Number($.trim($(row).find('#txtSequenceNo').val())) == 0) {
                IsCheckSequenceNo = 1;
                selectedRowSequence = row;
            }
        });

        //if (IsCheck == 1) {
        //    $('#lblMsg').text('To should be greater than or equal to From');
        //    $(SelectedRowid).find('#txtTo').focus();
        //    return false;
        //}

        if (IsCheckSequenceNo == 1) {
            $('#lblMsg').text('Please Enter Sequence Number');
            $(selectedRowSequence).find('#txtSequenceNo').focus();
            return false;
        }

        $('#btnSave').attr('disabled', true).val('Submitting...');

        $AgeingBuckets = [];
        $('#tableAgeingBuckets tbody tr').each(function (index, row) {
            $AgeingBuckets.push({
                Type: $.trim($('#ddlBucketType').val()),
                AgeingWho: $.trim($('#ddlAgeingWho').val()),
                SequenceNo: Number($.trim($(row).find('#txtSequenceNo').val())),
                FromLimit: Number($.trim($(row).find('#txtFrom').val())),
                ToLimit: Number($.trim($(row).find('#txtTo').val())),
            });
        });

        var ServiceURL = "";
        if (Number($("#spnControlforStore").text()) == 1)
            ServiceURL = "../../../Design/Common/CommonService.asmx/saveAgeingBuckets";
        else
            ServiceURL = "../Common/CommonService.asmx/saveAgeingBuckets";

        serverCall(ServiceURL, { AgeingBuckets: $AgeingBuckets }, function (response) {
            $responseData = JSON.parse(response);
            modelAlert($responseData.response, function (response) {
                if ($responseData.status)
                    $SearchBucketDetails();

                $('#btnSave').removeAttr('disabled').val('Save Same Buckets in Master');
            });
        });
    }
    function DeleteRow(rowid) {
        $(rowid).closest("tr").remove();
        $("#tableAgeingBuckets tbody tr:last").find('.imgPlus').show();
        //$("#tableAgeingBuckets tbody tr:last").find('.IsEdittable').removeAttr('disabled');
    }
    function AddRow(rowid) {
        $('#lblMsg').text('');
        if (Number($(rowid).closest("tr").find('#txtTo').val()) < Number($(rowid).closest("tr").find('#txtFrom').val())) {
            $('#lblMsg').text('To should be greater than or equal to From');
            $(rowid).closest("tr").find('#txtTo').focus();
            return false;
        }
        if (Number($(rowid).closest("tr").find('#txtSequenceNo').val()) == 0) {
            $('#lblMsg').text('Please Enter Sequence Number');
            $(rowid).closest("tr").find('#txtSequenceNo').focus();
            return false;
        }
	var path = '../../';
        if ($("#ddlAgeingWho").val() == "Stock")
            path = '../../../';
        $("#tableAgeingBuckets").find('.imgPlus').hide();
        //  $("#tableAgeingBuckets").find('.IsEdittable').attr('disabled', true);
        var From = Number($(rowid).closest("tr").find('#txtTo').val()) + 1;
        var SequenceNo = Number($(rowid).closest("tr").find('#txtSequenceNo').val()) + 1;
        var rowNo = Number($("#tableAgeingBuckets tbody tr").length) + 1;
        var BucketType = $(rowid).closest("tr").find('#tdType').text();
        var AgeingWho = $(rowid).closest("tr").find('#tdAgeingWho').text();
        $("#tableAgeingBuckets tbody").append("  <tr onmouseover='this.style.color='#00F'' onMouseOut='this.style.color=''' style='cursor:pointer;' id=" + rowNo + " >  " +
        " <td  class='GridViewLabItemStyle' id='tdSRNo' style='text-align:center;' >" + rowNo + "</td>  " +
         " <td  class='GridViewLabItemStyle' id='tdAgeingWho'style='text-align:center;' >" + AgeingWho + "</td> " +
          " <td  class='GridViewLabItemStyle' id='tdType'style='text-align:center;' >" + BucketType + "</td> " +
        " <td class='GridViewLabItemStyle' id='tdFrom' style='text-align:right;'> <input id='txtFrom' style='text-align:left;' onlynumber='3' value='" + From + "' onkeypress='$commonJsNumberValidation(event)' onkeydown='$commonJsPreventDotRemove(event)' class='requiredField IsEdittable' type='text' title='Enter To ' /></td> " +
        " <td class='GridViewLabItemStyle' id='tdTo' style='text-align:right;'> <input id='txtTo' style='text-align:left;' onlynumber='3'  onkeypress='$commonJsNumberValidation(event)' onkeydown='$commonJsPreventDotRemove(event)' class='requiredField IsEdittable' type='text' /> </td> " +
        " <td class='GridViewLabItemStyle' id='tdSequenceNo' style='text-align:right;'> <input id='txtSequenceNo' style='text-align:left;' onlynumber='2' max-value='50' value='" + SequenceNo + "' onkeypress='$commonJsNumberValidation(event)' onkeydown='$commonJsPreventDotRemove(event)' class='requiredField IsEdittable' type='text' /> </td> " +

        " <td class='GridViewLabItemStyle'><img alt='' src='"+ path +"Images/Post.gif' class='imgPlus' title='Add New Row' style='cursor:pointer' onclick='AddRow(this)'  /></td> " +
        " <td class='GridViewLabItemStyle'><img alt='' src='"+ path +"Images/Delete.gif' class='imgPlus' title='Delete Row' style='cursor:pointer' onclick='DeleteRow(this)'  /></td> " +
        " <td class='GridViewLabItemStyle' id='tdID' style='display:none;'>0</td> " +
        " </tr> ");
    }
</script>
    <div class="row">
        <span id="spnControlforStore" style="display:none">0</span>
        <div class="col-md-3">
            <label class="pull-left">
                Bucket For
            </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <asp:DropDownList ID="ddlAgeingWho" runat="server" ClientIDMode="Static" onchange=" $SearchBucketDetails(function(){});" TabIndex="4" ToolTip="Select Bucket Type">
                <asp:ListItem Value="0" Selected="True">Select</asp:ListItem>
                <asp:ListItem Value="Doctor">Doctor</asp:ListItem>
                <asp:ListItem Value="Panel" >Panel</asp:ListItem>
                <asp:ListItem Value="Hospital">Hospital</asp:ListItem>
                <asp:ListItem Value="Stock">Stock</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="col-md-3">
            <label class="pull-left">
                Bucket Type
            </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <asp:DropDownList ID="ddlBucketType" runat="server" ClientIDMode="Static" onchange=" $SearchBucketDetails(function(){});" TabIndex="4" ToolTip="Select Bucket Type">
                <asp:ListItem Value="Days" Selected="True">Days</asp:ListItem>
                <asp:ListItem Value="Months">Months</asp:ListItem>
                <asp:ListItem Value="Years">Years</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="col-md-3">
            <label class="pull-left">
            </label>
            <b class="pull-right"></b>
        </div>
        <div class="col-md-5">
        </div>

    </div>
    <div class="row">
        <div class="col-md-3">
            <label class="pull-left">
                Buckets
            </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-16">
            <div id="dvAgeingBuckets"></div>
        </div>
        <div class="col-md-3">
        </div>
    </div>
    <div class="row">
        <div class="col-md-19">
        </div>
        <div class="col-md-5">
            <input type="button" id="Button1" onclick="saveBuckets()" class="save" style="margin-left: 10px;" value="Save Same Buckets in Master" tabindex="7" />
        </div>
    </div>
<script id="tb_BucketDetails" type="text/html">
        <table  id="tableAgeingBuckets" cellspacing="0" rules="all" border="1" style="width:90%;border-collapse :collapse;">
            <thead>
                <tr id="TrHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;">S/No.</th>
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center; width:100px;" >Bucket For</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; width:100px;">Type</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">From</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">To</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Sequence No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;"></th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;"></th>
                    <th class="GridViewHeaderStyle" scope="col" style="display:none;">Id</th>
                </tr>
            </thead>
            <tbody>
            <#                       
                var dataLength=BucketDetails.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = BucketDetails[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" id="<#=j+1#>"
                     <#if(objRow.ID!="0"){#> style='cursor:pointer;background-color:lightgreen;' <#} else {#> style='cursor:pointer;' <#} #>  >   
                                                                             
                    <td  class="GridViewLabItemStyle" id="tdSRNo"style="text-align:center;" ><#=j+1#></td>
                    <td  class="GridViewLabItemStyle" id="tdAgeingWho"style="text-align:center;" ><#=objRow.AgeingWho#></td>
                    <td  class="GridViewLabItemStyle" id="tdType"style="text-align:center;" ><#=objRow.Type#></td>
                    <td class="GridViewLabItemStyle" id="tdFrom" style="text-align:right;" >
                          <input type="text" id="txtFrom" class="requiredField IsEdittable" onlynumber="4" style="text-align:left;"  onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" style="text-align:right;" value='<#=objRow.FromLimit#>'  />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdTo" style="text-align:right;" >
                        <input type="text" id="txtTo" class="requiredField IsEdittable" onlynumber="4" style="text-align:left;"  onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" style="text-align:right;" value='<#=objRow.ToLimit#>'  />
                    </td>
                    <td  class="GridViewLabItemStyle" id="tdSequenceNo"style="text-align:center;" >
                        <input type="text" id="txtSequenceNo" class="requiredField IsEdittable" onlynumber="2" style="text-align:left;" max-value="50" onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" style="text-align:right;" value='<#=objRow.SequenceNo#>'  />
                    </td>
                    <td class="GridViewLabItemStyle">
                        <#if(path !="../../")
                        {#>  
                        <img alt="" src="../../../Images/Post.gif" class="imgPlus" title="Add New Row" style="cursor:pointer" onclick="AddRow(this)"  />
                        <#} else {#>  
                     <img alt="" src="../../Images/Post.gif" class="imgPlus" title="Add New Row" style="cursor:pointer" onclick="AddRow(this)"  />
                    <#} #>    </td>
                       <td class="GridViewLabItemStyle">
                            <#if(path !="../../")
                        {#>  
                           <img alt="" src="../../../Images/Delete.gif" class="imgPlus" title="Delete Row" style="cursor:pointer" onclick="DeleteRow(this)"  />
                             <#} else {#>  
                     <img alt="" src="../../Images/Delete.gif" class="imgPlus" title="Delete Row" style="cursor:pointer" onclick="DeleteRow(this)"  />
                           <#} #>  
                       </td>

                    <td class="GridViewLabItemStyle" id="tdID" style="display:none"><#=objRow.ID#></td>                         
                </tr>            
            <#}#>
            </tbody>      
        </table>
</script>
